import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';

abstract class PageBlocCubit<State extends PageBlocState<UIEvent, UIState>, UIEvent, UIState>
    extends Cubit<State> {
  PageBlocCubit(super.initialState);

  void clearUIEvent() {
    print('----> clear');
    emit(createStateWithoutUIEvent(state));
  }

  State createStateWithoutUIEvent(State state);
}
