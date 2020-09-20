import 'package:flutter_test/flutter_test.dart';
import 'package:flyt/domain/book.dart';
import 'package:flyt/domain/book_reader.dart';
import 'package:flyt/services/book_reader_service.dart';
import 'package:flyt/util/UUID.dart';

void main() {
  final Book testBook = Book(null, "test title", "test author");

  test(
    'should fail if book has not yet been loaded',
    () {
      final BookReaderService brs = BookReaderService(
        BookReader(
          testBook,
          Identifier.generate(),
        ),
      );

      expect(
        () => brs.next(),
        throwsA(
          isA<BookContentNotLoadedException>().having(
              (source) => source.toString(),
              'message',
              'Content of "$testBook" was never initialized'),
        ),
      );
    },
  );
}
