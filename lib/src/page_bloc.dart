import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/src/page_bloc_event.dart';
import 'package:flutter_bloc_page/src/page_bloc_state.dart';
import 'package:nullable_absent/nullable_absent.dart';

abstract class PageBloc<BlocEvent, UiEvent, UiState> extends Bloc<
    PageBlocEvent<BlocEvent, UiEvent>, PageBlocState<UiEvent, UiState>> {
  PageBloc(super.initialState) {
    on<PageBlocEvent<BlocEvent, UiEvent>>((event, emit) async {
      await _handleEvent(event, emit);
    });
  }

  FutureOr<void> _handleEvent(PageBlocEvent<BlocEvent, UiEvent> event,
      Emitter<PageBlocState<UiEvent, UiState>> emit) async {
    final e = event;
    switch (e) {
      case NewEvent():
        return await handleEvent(e.blocEvent, emit);

      case ClearUiEvent():
        if (state.uiEvent == e.uiEvent) {
          emit(state.copyWith(uiEvent: const NullableAbsent(null)));
        }
    }
  }

  FutureOr<void> handleEvent(BlocEvent event,
      Emitter<PageBlocState<UiEvent, UiState>> emit);

  void addPageEvent(BlocEvent event) => add(NewEvent(blocEvent: event));
}
