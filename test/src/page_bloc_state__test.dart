// ignore_for_file: prefer_const_constructors
// ignore_for_file: unrelated_type_equality_checks

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nullable_absent/nullable_absent.dart';

typedef _PB = PageBlocState<int, String>;

void main() {
  group('copyWith', () {
    test('Create new instance', () {
      final state = _PB(uiState: 'uiState');
      final _PB copied = state.copyWith();
      expect(copied, state);
      expect(identical(state, copied), false);
    });

    group('Update ui event', () {
      test('null -> null', () {
        final state = _PB(uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(null));
        expect(copied, state);
        expect(identical(state, copied), false);
      });
      test('null -> value', () {
        final state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(2));
        expect(copied, _PB(uiEvent: 2, uiState: 'uiState'));
      });
      test('value -> value', () {
        final state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(1));
        expect(copied, state);
        expect(identical(state, copied), false);
      });
      test('value -> newValue', () {
        final state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(2));
        expect(copied, _PB(uiEvent: 2, uiState: 'uiState'));
      });
      test('value -> null', () {
        final state = _PB(uiEvent: 1, uiState: 'uiState');
        final PageBlocState<int, String> copied =
            state.copyWith(uiEvent: const NullableAbsent(null));
        expect(copied, _PB(uiState: 'uiState'));
      });
    });

    group('Update ui state', () {
      test('set to new value', () {
        final state = _PB(uiState: 'uiState');
        final _PB copied = state.copyWith(uiState: 'updated');
        expect(copied, _PB(uiState: 'updated'));
      });
      test('set to current value', () {
        final state = _PB(uiState: 'uiState');
        final _PB copied = state.copyWith(uiState: 'uiState');
        expect(copied, state);
        expect(identical(state, copied), false);
      });
    });

    group('Hashcode and ==', () {
      test('Equal value', () {
        final state1 = PageBlocState<String, String>(uiState: 'uiState');
        final state2 = PageBlocState<String, String>(uiState: 'uiState');
        expect(state1.hashCode == state2.hashCode, true);
        expect(state1 == state2, true);
      });

      test('Equal List', () {
        final state1 = PageBlocState<String, List<String>>(uiState: ['1', '2']);
        final state2 = PageBlocState<String, List<String>>(uiState: ['1', '2']);
        expect(state1.hashCode == state2.hashCode, false);
        expect(state1 == state2, false);
      });

      test('Not equal when different type', () {
        final state1 = PageBlocState<String, String>(uiState: 'uiState');
        final state2 = PageBlocState<int, String>(uiState: 'uiState');
        expect(state1.hashCode == state2.hashCode, false);
        expect(state1 == state2, false);
      });

      test('Not equal when different value', () {
        final state1 = PageBlocState<String, String>(uiState: 'uiState');
        final state2 = PageBlocState<String, String>(uiState: 'uiState1');
        expect(state1.hashCode == state2.hashCode, false);
        expect(state1 == state2, false);
      });

      test('Equal when uiEvent identical', () {
        final state1 = PageBlocState<MyUIEvent, String>(
            uiEvent: const MyUIEvent(text: 'test'), uiState: 'uiState');
        final state2 = PageBlocState<MyUIEvent, String>(
            uiEvent: const MyUIEvent(text: 'test'), uiState: 'uiState');
        expect(state1.hashCode == state2.hashCode, true);
        expect(state1 == state2, true);
      });

      test('Not equal when uiEvent not identical', () {
        final state1 = PageBlocState<MyUIEvent, String>(
            uiEvent: MyUIEvent(text: 'test'), uiState: 'uiState');
        final state2 = PageBlocState<MyUIEvent, String>(
            uiEvent: MyUIEvent(text: 'test'), uiState: 'uiState');
        expect(state1.hashCode == state2.hashCode, false);
        expect(state1 == state2, false);
      });
    });

    group('toString', () {
      test('Meaningful toString', () {
        final state1 = PageBlocState<MyUIEvent, String>(
            uiEvent: MyUIEvent(text: 'test'), uiState: 'uiState');
        expect(state1.toString(),
            'PageBlocState<MyUIEvent, String>(event: MyUIEvent(test), state: uiState)');
      });
    });
  });
}

class MyUIEvent extends Equatable {
  final String text;

  const MyUIEvent({required this.text});

  @override
  List<Object?> get props => [text];

  @override
  bool? get stringify => true;
}
