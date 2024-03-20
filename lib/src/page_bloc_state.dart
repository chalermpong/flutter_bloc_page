import 'package:equatable/equatable.dart';
import 'package:nullable_absent/nullable_absent.dart';

/// State to be used with [PageBlocConsumer]
///
/// This state class contains [UiEvent] and [UiState]
///
/// [UiEvent] represents event which need to be handled only once (e.g. show
/// dialog, show snackbar, open another page)
///
/// [UiState] represents state of UI.
class PageBlocState<UiEvent, UiState> extends Equatable {
  /// Event to be handled by UI.
  final UiEvent? uiEvent;

  /// State of UI.
  final UiState uiState;

  /// Create a new instance with [uiEvent] and [uiState]
  PageBlocState({this.uiEvent, required this.uiState});

  /// Copy this instance. Overriding [uiEvent] and [uiState] if specific value
  /// was given.
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
