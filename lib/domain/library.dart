import 'package:flyt/services/book_reader_service.dart';

class BookLibrary {
  final Set<BookReaderService> _bookshelf = Set();

  void addBookReader(BookReaderService bookReader) {
    _bookshelf.add(bookReader);
  }

  Set<BookReaderService> get bookshelf {
    return _bookshelf;
  }

  void clear() {
    _bookshelf.clear();
  }
}