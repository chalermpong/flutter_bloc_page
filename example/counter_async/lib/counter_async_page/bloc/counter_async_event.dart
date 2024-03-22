import 'package:equatable/equatable.dart';

sealed class CounterAsyncEvent extends Equatable {
  const CounterAsyncEvent();
}

class Click extends CounterAsyncEvent {
  const Click();

  @override
  List<Object?> get props => [];
}
