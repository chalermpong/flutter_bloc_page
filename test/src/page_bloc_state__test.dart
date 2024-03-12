import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nullable_absent/nullable_absent.dart';

typedef _PB = PageBlocState<int, String>;

void main() {
  group('copyWith', () {
    test('Create new instance', () {
      const state = _PB(uiState: 'uiState');
      final _PB copied = state.copyWith();
      expect(copied, state);
      expect(identical(state, copied), false);
    });

    group('Update ui event', () {
      test('null -> null', () {
        const state = _PB(uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(null));
        expect(copied, state);
        expect(identical(state, copied), false);
      });
      test('null -> value', () {
        const state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(2));
        expect(copied, const _PB(uiEvent: 2, uiState: 'uiState'));
      });
      test('value -> value', () {
        const state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(1));
        expect(copied, state);
        expect(identical(state, copied), false);
      });
      test('value -> newValue', () {
        const state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(2));
        expect(copied, const _PB(uiEvent: 2, uiState: 'uiState'));
      });
      test('value -> null', () {
        const state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(null));
        expect(copied, const _PB(uiState: 'uiState'));
      });
    });

    group('Update ui state', () {
      test('set to new value', () {
        const state = _PB(uiState: 'uiState');
        final _PB copied = state.copyWith(uiState: 'updated');
        expect(copied, const _PB(uiState: 'updated'));
      });
      test('set to current value', () {
        const state = _PB(uiState: 'uiState');
        final _PB copied = state.copyWith(uiState: 'uiState');
        expect(copied, state);
        expect(identical(state, copied), false);
      });
    });
  });
}
