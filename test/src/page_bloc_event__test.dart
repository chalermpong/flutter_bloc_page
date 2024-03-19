import 'package:flutter_bloc_page/flutter_bloc_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClearUiEvent', () {
    test('Same value same type', () {
      final event = ClearUiEvent<int, int>(uiEvent: 0);
      final another = ClearUiEvent<int, int>(uiEvent: 0);
      expect(event, another);
      expect(identical(event, another), false);
    });

    test('Same value different type', () {
      final event = ClearUiEvent<int, int>(uiEvent: 0);
      final another = ClearUiEvent<String, int>(uiEvent: 0);
      expect(event, isNot(another));
    });
  });

  group('NewEvent', () {
    test('Same value same type', () {
      final event = NewEvent<int, int>(blocEvent: 0);
      final another = NewEvent<int, int>(blocEvent: 0);
      expect(event, another);
      expect(identical(event, another), false);
    });

    test('Same value different type', () {
      final event = NewEvent<int, int>(blocEvent: 0);
      final another = NewEvent<int, String>(blocEvent: 0);
      expect(event, isNot(another));
    });
  });
}
