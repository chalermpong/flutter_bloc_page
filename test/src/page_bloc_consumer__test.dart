// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _PageBlocCubit bloc;
  late UiEventCapture eventCapture;
  late UiStateCapture stateCapture;

  setUpAll(() {
    registerFallbackValue(UiEvent(value: ""));
    registerFallbackValue(UiState(value: ""));
  });

  setUp(() {
    bloc = _PageBlocCubit(
        PageBlocState<UiEvent, UiState>(uiState: UiState(value: 'Hello')));
    eventCapture = UiEventCapture();
    stateCapture = UiStateCapture();
  });

  group("Display UiState", () {
    testWidgets('Initial State', (tester) async {
      await tester.pumpWidget(_TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      verifyNever(() => eventCapture.capture(captureAny()));
      final capturedState =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState, [UiState(value: "Hello")]);
    });

    testWidgets('No build when UiState not changed', (tester) async {
      await tester.pumpWidget(_TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      final event = UiEvent(value: "Event");
      bloc.emitNewUiEvent(event);
      await tester.pumpAndSettle();
      final capturedEvent =
          verify(() => eventCapture.capture(captureAny())).captured;
      expect(capturedEvent, [event]);
      final capturedState =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState, [UiState(value: "Hello")]);
    });

    testWidgets('Build when UiState changed', (tester) async {
      await tester.pumpWidget(_TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      verifyNever(() => eventCapture.capture(captureAny()));
      final capturedState1 =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState1, [UiState(value: "Hello")]);
      bloc.emitNewUiState(UiState(value: "Bye"));
      await tester.pumpAndSettle();
      verifyNever(() => eventCapture.capture(captureAny()));
      final capturedState2 =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState2, [UiState(value: "Bye")]);
    });

    testWidgets('Listener is not called when UiEvent not changed',
        (tester) async {
      await tester.pumpWidget(_TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      final event = UiEvent(value: "Event");
      bloc.emitNewState(event, UiState(value: "Hello"));
      await tester.pumpAndSettle();
      final capturedEvent1 =
          verify(() => eventCapture.capture(captureAny())).captured;
      expect(capturedEvent1, [event]);
      final capturedState1 =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState1, [UiState(value: "Hello")]);

      bloc.emitNewUiState(UiState(value: "Bye"));
      await tester.pumpAndSettle();

      verifyNever(() => eventCapture.capture(captureAny()));
      final capturedState2 =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState2, [
        UiState(value: "Bye"),
      ]);
    });

    testWidgets('Listener is called even when new event equals to previous one',
        (tester) async {
      await tester.pumpWidget(_TestWidget(
        bloc: bloc,
        eventCapture: eventCapture,
        stateCapture: stateCapture,
      ));
      final event1 = UiEvent(value: "Event");
      bloc.emitNewState(event1, UiState(value: "Hello"));
      await tester.pumpAndSettle();
      final capturedEvent1 =
          verify(() => eventCapture.capture(captureAny())).captured;
      expect(capturedEvent1, [event1]);
      final capturedState1 =
          verify(() => stateCapture.capture(captureAny())).captured;
      expect(capturedState1, [UiState(value: "Hello")]);

      final event2 = UiEvent(value: "Event");
      bloc.emitNewState(event2, UiState(value: "Hello"));
      await tester.pumpAndSettle();

      expect(event1, event2);
      final capturedEvent2 =
          verify(() => eventCapture.capture(captureAny())).captured;
      expect(capturedEvent2, [event2]);
      verifyNever(() => stateCapture.capture(captureAny()));
    });
  });
}

typedef TestBlocConsumer = PageBlocConsumer<_PageBlocCubit, UiEvent, UiState>;

class UiEvent extends Equatable {
  final String value;

  UiEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class UiState extends Equatable {
  final String value;

  const UiState({required this.value});

  @override
  List<Object?> get props => [value];
}

class _PageBlocCubit
    extends PageBlocCubit<PageBlocState<UiEvent, UiState>, UiEvent, UiState> {
  _PageBlocCubit(super.initialState);

  @override
  PageBlocState<UiEvent, UiState> createStateWithoutUIEvent(
      PageBlocState<UiEvent, UiState> state) {
    return PageBlocState<UiEvent, UiState>(uiState: state.uiState);
  }

  void emitNewState(UiEvent event, UiState state) {
    emit(PageBlocState<UiEvent, UiState>(uiEvent: event, uiState: state));
  }

  void emitNewUiEvent(UiEvent event) {
    emit(PageBlocState<UiEvent, UiState>(
        uiEvent: event, uiState: state.uiState));
  }

  void emitNewUiState(UiState state) {
    emit(PageBlocState<UiEvent, UiState>(
        uiEvent: this.state.uiEvent, uiState: state));
  }
}

abstract class Capture<T> {
  void capture(T value);
}

class UiEventCapture extends Mock implements Capture<UiEvent> {}

class UiStateCapture extends Mock implements Capture<UiState> {}

class _TestWidget extends StatelessWidget {
  final _PageBlocCubit bloc;
  final UiEventCapture eventCapture;
  final UiStateCapture stateCapture;

  const _TestWidget(
      {required this.bloc,
      required this.eventCapture,
      required this.stateCapture});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<_PageBlocCubit>(
        create: (context) => bloc,
        child: Builder(
          builder: (context) => TestBlocConsumer(
            uiEventListener: (context, uiEvent) async {
              eventCapture.capture(uiEvent);
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
