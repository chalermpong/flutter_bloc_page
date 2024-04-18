import 'package:equatable/equatable.dart';

class CounterAsyncStateUiState extends Equatable {
  final int counter;
  final bool isLoading;

  const CounterAsyncStateUiState({
    required this.counter,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [counter, isLoading];

  CounterAsyncStateUiState copyWith({
    int? counter,
    bool? isLoading,
  }) {
    return CounterAsyncStateUiState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

sealed class CounterAsyncStateUiEvent {
  CounterAsyncStateUiEvent();
}

class ShowAlertDialog extends CounterAsyncStateUiEvent {
  final String title;
  final String message;

  ShowAlertDialog({required this.title, required this.message});
}
