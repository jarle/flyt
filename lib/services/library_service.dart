import 'dart:developer' as developer;
import 'dart:io';

import 'package:flyt/domain/book.dart';
import 'package:flyt/domain/book_reader.dart';
import 'package:flyt/domain/library.dart';
import 'package:flyt/model/model.dart';
import 'package:flyt/util/UUID.dart';

import 'book_reader_service.dart';

class BookLibraryService {
  final BookLibrary _library = BookLibrary();

  initState() async {
//    await clearDatabase();
    final List<BookReaderEntity> bookReaderEntries =
        await BookReaderEntity().select().toList(preload: true);
    developer.log(
        "Initializing ${bookReaderEntries.length} book readers from database");
    return bookReaderEntries.map(_toBookReader).forEach(_addBookReader);
  }

  Future clearDatabase() async {
    developer.log("Cleaning database");
    await BookReaderEntity().select().delete(true);
    await BookEntity().select().delete(true);
    await BookLibraryEntity().select().delete(true);
    _library.clear();
    developer.log("Done cleaning database");
  }

  Future<void> _addBookReader(BookReader reader) async {
    _library.addBookReader(BookReaderService(reader));
  }

  Future<void> addNewBook(Book book) async {
    developer.log("Adding new book $book to database");
    final Identifier identifier = Identifier.generate();
    final BookReader reader = BookReader(book, identifier);
    final bookReaderEntity = new BookReaderEntity(
        id: identifier.id, cursorPosition: reader.cursorPosition);

    bookReaderEntity.bookentity = BookEntity(
        author: book.author, title: book.title, path: book.file.path);

    await bookReaderEntity.save();

    developer.log(
        "Successfully added reader for ${reader.book} to database with ID ${bookReaderEntity.id}");
    _addBookReader(reader);
    final entities = await BookReaderEntity().select().toList();
    developer.log("Database now contains ${entities.length} book readers");
  }

  Set<BookReaderService> get bookReaders {
    return _library.bookshelf;
  }

  BookReader _toBookReader(BookReaderEntity readerEntity) {
    developer.log(
        "Initializing BookReader from Entity: ${readerEntity.id} with cursorPosition ${readerEntity.cursorPosition}");
    final BookEntity bookEntity = readerEntity.bookentity;
    final BookReader bookReader = BookReader(
        Book(new File(bookEntity.path), bookEntity.title, bookEntity.author),
        Identifier(readerEntity.id));
    bookReader.cursorPosition = readerEntity.cursorPosition;
    developer.log("Instantiated $bookReader");
    return bookReader;
  }
}
