import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/src/page_bloc.dart';
import 'package:flutter_bloc_page/src/page_bloc_event.dart';
import 'package:flutter_bloc_page/src/page_bloc_state.dart';

/// [BlocConsumer] to be used with [pageBloc].
///
/// It triggers [uiEventListener] on new [UiEvent] and clears it automatically.
/// So [UiEvent] will be executed only once.
///
/// It also triggers [uiBuilder] on [UiState] changed.
class PageBlocConsumer<BlocEvent, UiEvent extends Equatable,
        UiState extends Equatable>
    extends BlocConsumer<StateStreamable<PageBlocState<UiEvent, UiState>>,
        PageBlocState<UiEvent, UiState>> {
  /// Create new instance
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

  /// [PageBloc] to be used with.
  final PageBloc<BlocEvent, UiEvent, UiState> pageBloc;

  /// Takes the `BuildContext` along with the [PageBloc] `uiEvent`
  /// and is responsible for executing in response to new `uiEvent`.
  final BlocWidgetListener<UiEvent> uiEventListener;

  /// The [uiBuilder] function which will be invoked on each widget build.
  /// The [uiBuilder] takes the `BuildContext` and current `uiState` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final BlocWidgetBuilder<UiState> uiBuilder;
}
