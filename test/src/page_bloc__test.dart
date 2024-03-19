import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nullable_absent/nullable_absent.dart';

void main() {
  late TestPageBloc bloc;

  setUp(() {
    bloc = TestPageBloc(const PageBlocState(uiState: "Hello"));
  });

  tearDown(() {
    bloc.close();
  });

  group('PageBloc New Event Tests', () {
    blocTest<TestPageBloc, PageBlocState<String, String>>(
      'No emit',
      build: () => bloc,
      act: (bloc) => bloc.addPageEvent(const BlocEvent()),
      expect: () => [],
    );

    blocTest<TestPageBloc, PageBlocState<String, String>>(
      'Emit new event',
      build: () => bloc,
      act: (bloc) => bloc.addPageEvent(const BlocEvent(event: "Test Event")),
      expect: () =>
          [const PageBlocState(uiEvent: "Test Event", uiState: "Hello")],
    );

    blocTest<TestPageBloc, PageBlocState<String, String>>(
      'Emit new state',
      build: () => bloc,
      act: (bloc) => bloc.addPageEvent(const BlocEvent(state: "Test State")),
      expect: () => [
        const PageBlocState<String, String>(
            uiEvent: null, uiState: "Test State")
      ],
    );
    blocTest<TestPageBloc, PageBlocState<String, String>>(
      'Emit new event and state',
      build: () => bloc,
      act: (bloc) => bloc.addPageEvent(
          const BlocEvent(event: "Test Event", state: "Test State")),
      expect: () => [
        const PageBlocState<String, String>(
            uiEvent: "Test Event", uiState: "Hello"),
        const PageBlocState<String, String>(
            uiEvent: "Test Event", uiState: "Test State")
      ],
    );
  });

  group('PageBloc Clear Event Tests', () {
    blocTest<TestPageBloc, PageBlocState<String, String>>(
      'Clear event: match',
      build: () => TestPageBloc(
          const PageBlocState(uiEvent: "Test Event", uiState: "Hello")),
      act: (bloc) => bloc.add(const ClearUiEvent(uiEvent: "Test Event")),
      expect: () => [
        const PageBlocState<String, String>(uiEvent: null, uiState: "Hello")
      ],
    );

    blocTest<TestPageBloc, PageBlocState<String, String>>(
      'Clear event: not match',
      build: () => TestPageBloc(
          const PageBlocState(uiEvent: "Test Event1", uiState: "Hello")),
      act: (bloc) => bloc.add(const ClearUiEvent(uiEvent: "Test Event")),
      expect: () => [],
    );
  });
}

typedef _$<T> = NullableAbsent<T>;

class BlocEvent extends Equatable {
  final String? event;
  final String? state;

  const BlocEvent({this.event, this.state});

  @override
  List<Object?> get props => [event, state];
}

class TestPageBloc extends PageBloc<BlocEvent, String, String> {
  TestPageBloc(super.initialState);

  @override
  FutureOr<void> handleEvent(
      BlocEvent blocEvent, Emitter<PageBlocState<String, String>> emit) {
    final event = blocEvent.event;
    if (event != null) {
      emit(state.copyWith(uiEvent: _$(event)));
    }
    final uiState = blocEvent.state;
    if (uiState != null) {
      emit(state.copyWith(uiState: uiState));
    }
  }
}