import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/src/page_bloc_event.dart';
import 'package:flutter_bloc_page/src/page_bloc_state.dart';
import 'package:nullable_absent/nullable_absent.dart';

/// PageBloc is code template for Bloc that controls one page
///
/// State of [PageBloc] consists of [UiEvent] and [UiState]
///
/// [UiEvent] represents an event that UI need to react with.
/// For example, showing error dialog when error occurred.
///
/// [UiState] represents the state of UI.
/// Just like [State] of normal [Bloc].
abstract class PageBloc<BlocEvent, UiEvent, UiState> extends Bloc<
    PageBlocEvent<BlocEvent, UiEvent>, PageBlocState<UiEvent, UiState>> {
  /// Create a PageBloc with [initialState]
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

  /// Event handler for [BlocEvent].
  /// Emit zero or more states via the [Emitter].
  FutureOr<void> handleEvent(
      BlocEvent event, Emitter<PageBlocState<UiEvent, UiState>> emit);

  /// Notifies the [PageBloc] of a new [BlocEvent]
  void addPageEvent(BlocEvent event) => add(NewEvent(blocEvent: event));
}
