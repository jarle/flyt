import 'dart:developer' as developer;
import 'dart:math';

import 'package:epub/epub.dart';
import 'package:flyt/domain/book.dart';
import 'package:flyt/domain/book_chapter.dart';
import 'package:flyt/domain/book_reader.dart';
import 'package:flyt/domain/content.dart';
import 'package:flyt/domain/paragraph.dart';
import 'package:flyt/model/model.dart';
import 'package:flyt/services/book_indexing_service.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:xml/xml.dart' as xml;

class BookReaderService {
  final BookReader _bookReader;
  Content _content = Content();
  BookIndex bookIndex = BookIndex.empty();

  BookReaderService(this._bookReader);

  int get cursorPosition => _bookReader.cursorPosition;

  int get contentLength => _content.length;

  Book get book => _bookReader.book;

  Future<BookReaderService> loadContent() async {
    List<BookChapter> chapters = await _readChaptersFromDisk();
    _content = toContent(chapters);
    bookIndex = _indexBook(chapters);
    return this;
  }

  Future<List<BookChapter>> _readChaptersFromDisk() async {
    final List<int> bytes = await book.file.readAsBytes();
    final EpubBook epubBook = await EpubReader.readBook(bytes);
    final List<BookChapter> chapters = epubBook.Chapters.asMap()
        .map((index, chapter) => MapEntry(
            index,
            BookChapter(
                chapter.Title, this.toParagraphs(chapter.HtmlContent), index)))
        .values
        .toList();
    return chapters;
  }

  BookIndex _indexBook(chapters) => BookIndexingService.indexBook(chapters);

  static Content toContent(List<BookChapter> chapters) {
    final Content result = Content(chapters
        .expand((chapter) =>
            chapter.paragraphs.expand((paragraph) => paragraph.tokenizedWords))
        .toList());

    developer.log("Loaded ${result.length} tokenized words");
    return result;
  }

  List<Paragraph> toParagraphs(String htmlParagraphs) {
    return xml
        .parse(htmlParagraphs)
        .children
        .map((node) => Paragraph(node.text))
        .toList();
  }

  String next() {
    try {
      return _content.content()[_bookReader.nextPosition() %
          (_content.length - 1)]; //TODO: no wraparound
    } on ContentNotLoadedException {
      throw BookContentNotLoadedException(book);
    }
  }

  String current() {
    try {
      return _content.content()[_bookReader.cursorPosition %
          (_content.length - 1)]; //TODO: no wraparound
    } on ContentNotLoadedException {
      throw BookContentNotLoadedException(book);
    }
  }

  void skip(int wordsToSkip) {
    var newPosition = cursorPosition + wordsToSkip;
    if (newPosition < contentLength && newPosition >= 0) {
      developer.log("Skipping $wordsToSkip words, to position $newPosition.");
      _bookReader.skip(wordsToSkip);
    }
  }

  String above() {
    return "${_content.content().getRange(max(cursorPosition - 100, 0), max(cursorPosition - 1, 0)).join(" ")}";
  }

  String below() {
    return "${_content.content().getRange(cursorPosition + 1, min(cursorPosition + 200, _content.length)).join(" ")}";
  }

  Future updateCursorPosition() async {
    developer.log(
        "Updating cursorPosition (at ${_bookReader.cursorPosition}) for ${_bookReader.id}");
    final BoolResult result = await BookReaderEntity()
        .select()
        .id
        .equals(_bookReader.id.id)
        .update(({"cursorPosition": _bookReader.cursorPosition}));

    developer.log("$result");
    developer.log("cursorPosition updated for ${_bookReader.id}");

    var list = await BookReaderEntity()
        .select()
        .id
        .equals(_bookReader.id.id)
        .toList(preload: true);
    list.forEach((element) => developer.log("${element.cursorPosition}"));
  }

  void forward() {
    developer.log("Skipping forward");
    _bookReader.forward();
  }

  void backward() {
    developer.log("Skipping backward");
    _bookReader.backward();
  }

  void moveCursorTo(int newPosition) {
    developer.log("Moving cursor to position $newPosition");
    _bookReader.setPosition(newPosition);
  }

  ChapterIndex currentChapter() {
    return bookIndex.currentChapter(GCursor(cursorPosition));
  }

  double chapterProgress() {
    developer.log("Calculating chapter progress for position $cursorPosition");
    return 100 *
        ((cursorPosition) /
            (currentChapter().position.cursor + currentChapter().length));
  }

  double bookProgress() {
    developer.log("Calculating book progress for position $cursorPosition");
    return 100 * (cursorPosition / bookIndex.length);
  }
}

class BookContentNotLoadedException implements Exception {
  final Book book;

  const BookContentNotLoadedException(this.book);

  @override
  String toString() => 'Content of "$book" was never initialized';
}
