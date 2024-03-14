import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:nullable_absent/nullable_absent.dart';

import 'counter_async_event.dart';
import 'counter_async_state.dart';

typedef _$<T> = NullableAbsent<T>;

class CounterAsyncBloc extends PageBloc<CounterAsyncEvent,
    CounterAsyncStateUiEvent, CounterAsyncStateUiState> {
  CounterAsyncBloc(super.initialState);

  @override
  FutureOr<void> handleEvent(
      CounterAsyncEvent event,
      Emitter<PageBlocState<CounterAsyncStateUiEvent, CounterAsyncStateUiState>>
          emit) async {
    switch (event) {
      case Click():
        emit(state.copyWith(
          uiState: state.uiState.copyWith(isLoading: true),
        ));
        // Simulate asynchronous delay
        await Future.delayed(const Duration(seconds: 1));
        if (Random().nextBool()) {
          // Simulate error
          emit(state.copyWith(
            uiEvent: _$(ShowErrorDialog(error: Exception("Error!"))),
            uiState: state.uiState.copyWith(isLoading: false),
          ));
        } else {
          final counter = state.uiState.counter;
          if ((counter + 1) == 3) {
            emit(state.copyWith(
              uiEvent: const _$(
                  ShowAlertDialog(title: "Hooray!!!", message: "You got 3")),
              uiState: state.uiState.copyWith(
                counter: counter + 1,
                isLoading: false,
              ),
            ));
          } else {
            emit(state.copyWith(
              uiState: state.uiState.copyWith(
                counter: counter + 1,
                isLoading: false,
              ),
            ));
          }
        }
    }
  }
}
