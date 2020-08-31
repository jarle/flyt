import 'package:flutter_test/flutter_test.dart';
import 'package:flyt/domain/book.dart';
import 'package:flyt/services/book_reader_service.dart';

void main() {
  test('should be equal', () {
    expect(Book(null, "test title", "test author"), equals(Book(null, "test title", "test author")));
  });

  test('should not equal', () {
    expect(Book(null, "1", "test author"), isNot(equals(Book(null, "2", "test author"))));
  });
}
