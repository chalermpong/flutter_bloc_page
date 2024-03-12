import 'package:equatable/equatable.dart';

class CounterAsyncStateUiState extends Equatable {
  final int counter;

  const CounterAsyncStateUiState({required this.counter});

  @override
  List<Object?> get props => [counter];
}

sealed class CounterAsyncStateUiEvent extends Equatable {
  const CounterAsyncStateUiEvent();
}

class ShowAlertDialog extends CounterAsyncStateUiEvent {
  final String title;
  final String message;

  const ShowAlertDialog({required this.title, required this.message});

  @override
  List<Object?> get props => [title, message];
}

class ShowErrorDialog extends CounterAsyncStateUiEvent {
  final Exception error;

  const ShowErrorDialog({required this.error});

  @override
  List<Object?> get props => [error];
}
