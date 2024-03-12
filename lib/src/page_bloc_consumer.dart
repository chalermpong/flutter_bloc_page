import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/src/page_bloc.dart';
import 'package:flutter_bloc_page/src/page_bloc_event.dart';
import 'package:flutter_bloc_page/src/page_bloc_state.dart';

class PageBlocConsumer<BlocEvent, UiEvent extends Equatable,
        UiState extends Equatable>
    extends BlocConsumer<StateStreamable<PageBlocState<UiEvent, UiState>>,
        PageBlocState<UiEvent, UiState>> {
  PageBlocConsumer({
    super.key,
    required this.pageBloc,
    required this.uiEventListener,
    required this.uiBuilder,
  }) : super(
            bloc: pageBloc,
            listenWhen: (prev, current) => prev.uiEvent != current.uiEvent,
            listener: (context, state) {
              final uiEvent = state.uiEvent;
              if (uiEvent != null) {
                uiEventListener(context, uiEvent);
                pageBloc.add(ClearUiEvent(uiEvent: uiEvent));
              }
            },
            buildWhen: (prev, current) => prev.uiState != current.uiState,
            builder: (context, state) => uiBuilder(context, state.uiState));

  final PageBloc<BlocEvent, UiEvent, UiState> pageBloc;
  final BlocWidgetListener<UiEvent> uiEventListener;
  final BlocWidgetBuilder<UiState> uiBuilder;
}
