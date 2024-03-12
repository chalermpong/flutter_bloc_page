import 'package:equatable/equatable.dart';
import 'package:nullable_absent/nullable_absent.dart';

class PageBlocState<UiEvent, UiState> extends Equatable {
  final UiEvent? uiEvent;
  final UiState uiState;

  const PageBlocState({this.uiEvent, required this.uiState});

  PageBlocState<UiEvent, UiState> copyWith({
    NullableAbsent<UiEvent> uiEvent = const NullableAbsent.absent(),
    UiState? uiState,
  }) {
    return PageBlocState(
      uiEvent: NullableAbsent(this.uiEvent).apply(uiEvent),
      uiState: uiState ?? this.uiState,
    );
  }

  @override
  List<Object?> get props => [uiEvent, uiState];
}
