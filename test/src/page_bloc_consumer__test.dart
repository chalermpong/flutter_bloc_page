import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockBloc bloc;
  late StreamController<PageBlocState<UiEvent, UiState>> blocStream;
  late UiEventCapture eventCapture;
  late UiStateCapture stateCapture;

  setUpAll(() {
    registerFallbackValue(const UiEvent(value: ""));
    registerFallbackValue(const UiState(value: ""));
  });

  setUp(() {
    bloc = MockBloc();
    when(() => bloc.state)
        .thenReturn(const PageBlocState(uiState: UiState(value: "Hello")));
    blocStream = StreamController<PageBlocState<UiEvent, UiState>>();
    when(() => bloc.stream).thenAnswer((_) => blocStream.stream);
    eventCapture = UiEventCapture();
    stateCapture = UiStateCapture();
  });

  tearDown(() {
    blocStream.close();
  });

  group("Display UiState", () {
    testWidgets('Initial State', (tester) async {
      await tester.pumpWidget(TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      verifyNever(() => eventCapture.capture(captureAny()));
      final capturedState =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState, [const UiState(value: "Hello")]);
    });

    testWidgets('No build when UiState not changed', (tester) async {
      await tester.pumpWidget(TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      blocStream.add(const PageBlocState(
          uiEvent: UiEvent(value: "Event"), uiState: UiState(value: "Hello")));
      await tester.pumpAndSettle();
      final capturedEvent =
          verify(() => eventCapture.capture(captureAny())).captured;
      expect(capturedEvent, [const UiEvent(value: "Event")]);
      final capturedState =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState, [const UiState(value: "Hello")]);
    });

    testWidgets('Build when UiState changed', (tester) async {
      await tester.pumpWidget(TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      blocStream.add(const PageBlocState(uiState: UiState(value: "Bye")));
      await tester.pumpAndSettle();
      verifyNever(() => eventCapture.capture(captureAny()));
      final capturedState =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState, [
        const UiState(value: "Hello"),
        const UiState(value: "Bye"),
      ]);
    });

    testWidgets('UiEvent is cleared after handled', (tester) async {
      await tester.pumpWidget(
        TestWidget(
          bloc: bloc,
          eventCapture: eventCapture,
          stateCapture: stateCapture,
        ),
      );
      blocStream.add(const PageBlocState(
          uiEvent: UiEvent(value: "Event"), uiState: UiState(value: "Hello")));
      await tester.pumpAndSettle();

      final dismissButton = find.byKey(const Key("uiEvent.dismiss"));
      await tester.tap(dismissButton);
      verify(() =>
              bloc.add(const ClearUiEvent(uiEvent: UiEvent(value: "Event"))))
          .called(1);
    });
  });
}

typedef TestBlocConsumer = PageBlocConsumer<int, UiEvent, UiState>;

class UiEvent extends Equatable {
  final String value;

  const UiEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class UiState extends Equatable {
  final String value;

  const UiState({required this.value});

  @override
  List<Object?> get props => [value];
}

class MockBloc extends Mock implements PageBloc<int, UiEvent, UiState> {}

abstract class Capture<T> {
  void capture(T value);
}

class UiEventCapture extends Mock implements Capture<UiEvent> {}

class UiStateCapture extends Mock implements Capture<UiState> {}

class TestWidget extends StatelessWidget {
  final MockBloc bloc;
  final UiEventCapture eventCapture;
  final UiStateCapture stateCapture;

  const TestWidget(
      {super.key,
      required this.bloc,
      required this.eventCapture,
      required this.stateCapture});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<MockBloc>(
        create: (context) => bloc,
        child: Builder(
          builder: (context) => TestBlocConsumer(
            pageBloc: bloc,
            uiEventListener: (context, uiEvent) async {
              eventCapture.capture(uiEvent);
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("UI Event"),
                        content: Text(uiEvent.value),
                        actions: <Widget>[
                          TextButton(
                            key: const Key("uiEvent.dismiss"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Dismiss'),
                          ),
                        ],
                      ));
            },
            uiBuilder: (context, uiState) {
              stateCapture.capture(uiState);
              return Text(uiState.value);
            },
          ),
        ),
      ),
    );
  }
}
