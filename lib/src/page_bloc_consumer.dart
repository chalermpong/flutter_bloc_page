import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/src/page_bloc_state.dart';

/// [PageBlocConsumer] extended [BlocConsumer] for using with [PageBlocState].
///
/// [uiEventListener] is called on new [UiEvent] (`identical` returned false).
/// So event listener is called even when new event == old event.
///
/// *IMPORTANT* Avoid using `const` constructor on [UiEvent] because
/// `uiEventListener` will not be called again on identical event.
///
/// [uiBuilder] is called on [UiState] changed (== returned false).
class PageBlocConsumer<
    B extends StateStreamable<PageBlocState<UiEvent, UiState>>,
    UiEvent,
    UiState> extends BlocConsumer<B, PageBlocState<UiEvent, UiState>> {
  /// Create new instance
  PageBlocConsumer({
    super.key,
    super.bloc,
    required this.uiEventListener,
    required this.uiBuilder,
  }) : super(
            listenWhen: (prev, current) =>
                !identical(prev.uiEvent, current.uiEvent),
            listener: (context, state) {
              final uiEvent = state.uiEvent;
              if (uiEvent != null) {
                uiEventListener(context, uiEvent);
              }
            },
            buildWhen: (prev, current) => prev.uiState != current.uiState,
            builder: (context, state) => uiBuilder(context, state.uiState));

  /// Takes the `BuildContext` along with the [PageBlocState] `uiEvent`
  /// and is responsible for executing in response to new `uiEvent`.
  final BlocWidgetListener<UiEvent> uiEventListener;

  /// The [uiBuilder] function which will be invoked on each widget build.
  /// The [uiBuilder] takes the `BuildContext` and current `uiState` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final BlocWidgetBuilder<UiState> uiBuilder;
}
