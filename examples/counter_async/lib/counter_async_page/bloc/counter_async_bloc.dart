import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:nullable_absent/nullable_absent.dart';

import 'counter_async_event.dart';
import 'counter_async_state.dart';

typedef _$<T> = NullableAbsent<T>;

class CounterAsyncBloc extends Bloc<CounterAsyncEvent,
    PageBlocState<CounterAsyncStateUiEvent, CounterAsyncStateUiState>> {
  CounterAsyncBloc(super.initialState) {
    on<CounterAsyncEvent>((event, emit) async {
      switch (event) {
        case Click():
          emit(state.copyWith(
            uiState: state.uiState.copyWith(isLoading: true),
          ));
          // Simulate asynchronous delay
          await Future.delayed(const Duration(seconds: 1));

          final counter = state.uiState.counter;
          if ((counter + 1) % 2 == 0) {
            emit(state.copyWith(
              uiEvent: _$(ShowAlertDialog(
                  title: "Hooray!!!", message: "You got even number")),
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
    });
  }
}
