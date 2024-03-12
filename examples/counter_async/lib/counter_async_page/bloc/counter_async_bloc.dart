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
        // Simulate asynchronous delay
        await Future.delayed(const Duration(seconds: 1));
        if (Random().nextBool()) {
          // Simulate error
          emit(state.copyWith(
              uiEvent: _$(ShowErrorDialog(error: Exception("Error!")))));
        } else {
          final counter = state.uiState.counter;
          if (counter == 3) {
            emit(state.copyWith(
              uiEvent: const _$(
                  ShowAlertDialog(title: "Hooray!!!", message: "You got 3")),
              uiState: CounterAsyncStateUiState(counter: counter + 1),
            ));
          } else {
            emit(state.copyWith(
              uiState: CounterAsyncStateUiState(counter: counter + 1),
            ));
          }
        }
    }
  }
}
