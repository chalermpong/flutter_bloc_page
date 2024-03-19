import 'package:equatable/equatable.dart';

/// Event class for using with [PageBloc]
sealed class PageBlocEvent<BlocEvent, UiEvent> extends Equatable {
  const PageBlocEvent();
}

/// Event indicates [PageBloc] to clear [uiEvent] from bloc `state`.
class ClearUiEvent<BlocEvent, UiEvent>
    extends PageBlocEvent<BlocEvent, UiEvent> {
  /// [UiEvent] to be cleared.
  final UiEvent uiEvent;

  /// Create an event to clear [uiEvent] from [PageBloc].
  const ClearUiEvent({required this.uiEvent});

  @override
  List<Object?> get props => [uiEvent];
}

/// Event indicates new [BlocEvent] to [PageBloc].
class NewEvent<BlocEvent, UiEvent> extends PageBlocEvent<BlocEvent, UiEvent> {
  /// The [BlocEvent] to be added to [PageBloc]
  final BlocEvent blocEvent;

  /// Create a new [BlocEvent]
  const NewEvent({required this.blocEvent});

  @override
  List<Object?> get props => [blocEvent];
}
