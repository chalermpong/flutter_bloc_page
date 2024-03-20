Helper package for creating Bloc for controlling one UI Page.

## Features

Build on top of flutter_bloc `BlocConsumer` widget, flutter_bloc_page provides better separation
between UI state
and UI event.

UI state will be last until bloc emit a new state.

While UI event (e.g. show snackbar, show dialog, open another page) should be handled only once.

## Getting started

### Pubspec

```yaml
dependencies:
  flutter_bloc_page: ^1.0.0
```

## Usage

When create a page, define `UiEvent` class to represent event that can happen.

Let say it will be 2 events: showDialog and openAnotherPage. You can define `UiEvent` class like
this.

```dart
sealed class UiEvent {}

class ShowDialog extends UiEvent {
  // Fields
}

class OpenAnotherPage extends UiEvent {
  // Fields
}
```

*Note* Avoid having `const` constructor in `UiEvent` class. `PageBlocConsumer` uses `identical` for
checking arrival of new UiEvent.

Create a Bloc with `state` of type `PageBlocState`. Implement your Bloc logic as normal bloc.
```dart
class YourBloc extends Bloc<Event, PageBlocState<UiEvent, UiState>> {
  // Your implementation
}
```

Now you can use `PageBlocConsumer`:

```dart
PageBlocConsumer<YourBloc, UiEvent, UiState>
(
uiEventListener: (context, uiEvent) async {
// Handle UiEvent
},
uiBuilder: (context, uiState) {
// Build your widget from UiState  
}
);
```



