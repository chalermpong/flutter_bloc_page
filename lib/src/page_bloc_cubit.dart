import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';

/// Cubit for using with [PageBlocConsumer]
abstract class PageBlocCubit<State extends PageBlocState<UIEvent, UIState>,
    UIEvent, UIState> extends Cubit<State> {
  /// Create PageBlocCubit
  PageBlocCubit(super.initialState);

  /// Call this function after [uiEvent] is handled
  void clearUIEvent() {
    emit(createStateWithoutUIEvent(state));
  }

  /// Create a new instance of [State] with [uiEvent] = null
  State createStateWithoutUIEvent(State state);
}
