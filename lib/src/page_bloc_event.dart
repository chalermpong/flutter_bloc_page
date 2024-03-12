import 'package:equatable/equatable.dart';

sealed class PageBlocEvent<BlocEvent, UiEvent> extends Equatable {
  const PageBlocEvent();
}

class ClearUiEvent<BlocEvent, UiEvent>
    extends PageBlocEvent<BlocEvent, UiEvent> {
  final UiEvent uiEvent;

  const ClearUiEvent({required this.uiEvent});

  @override
  List<Object?> get props => [uiEvent];
}

class NewEvent<BlocEvent, UiEvent> extends PageBlocEvent<BlocEvent, UiEvent> {
  final BlocEvent blocEvent;

  const NewEvent({required this.blocEvent});

  @override
  List<Object?> get props => [blocEvent];
}
