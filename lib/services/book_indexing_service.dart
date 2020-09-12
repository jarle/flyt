import 'dart:developer' as developer;
import 'package:flyt/domain/book_chapter.dart';
import 'package:flyt/domain/paragraph.dart';
import 'package:flyt/domain/sentence.dart';

class BookIndexingService {
  static BookIndex indexBook(List<BookChapter> chapters) {
    return chapters.fold(BookIndex([]), foldChapter);
  }

  static BookIndex foldChapter(BookIndex currentIndex, BookChapter newChapter) {
    return BookIndex(
        [...currentIndex.chapters, indexChapter(currentIndex, newChapter)]);
  }

  static ChapterIndex indexChapter(
      BookIndex currentIndex, BookChapter newChapter) {
    developer.log(
        "Indexing chapter ${newChapter.title} at index ${currentIndex.length}");
    return newChapter.paragraphs.fold(
        ChapterIndex(GCursor(currentIndex.length), [], newChapter.title),
        foldParagraph);
  }

  static ChapterIndex foldParagraph(
      ChapterIndex currentChapter, Paragraph newParagraph) {
    return ChapterIndex(
        currentChapter.position,
        [
          ...currentChapter.paragraphs,
          indexParagraph(currentChapter, newParagraph),
        ],
        currentChapter.title);
  }

  static ParagraphIndex indexParagraph(
      ChapterIndex currentChapter, Paragraph newParagraph) {
    return newParagraph.sentences.fold(
        ParagraphIndex(currentChapter.position.plus(currentChapter.length), []),
        foldSentence);
  }

  static ParagraphIndex foldSentence(
      ParagraphIndex currentParagraph, Sentence sentence) {
    return ParagraphIndex(currentParagraph.position, [
      ...currentParagraph.sentences,
      SentenceIndex(
          currentParagraph.position.plus(currentParagraph.length), sentence)
    ]);
  }
}

class BookIndex {
  final List<ChapterIndex> chapters;
  final int length;

  BookIndex(this.chapters) : length = calculateLength(chapters);

  static int calculateLength(List<ChapterIndex> chapters) {
    return chapters.map((e) => e.length).fold(0, sum);
  }

  static empty() {
    return BookIndex([]);
  }
}

int sum(value, element) => value + element;

class ChapterIndex {
  final String _title;
  final GCursor position;
  final List<ParagraphIndex> paragraphs;
  final int length;

  ChapterIndex(this.position, this.paragraphs, this._title)
      : length = calculateLength(paragraphs);

  get title => _title;

  static int calculateLength(List<ParagraphIndex> sentences) {
    return sentences.map((e) => e.length).fold(0, sum);
  }
}

class ParagraphIndex {
  final GCursor position;
  final List<SentenceIndex> sentences;
  final int length;

  ParagraphIndex(this.position, this.sentences)
      : length = calculateLength(sentences);

  static int calculateLength(List<SentenceIndex> sentences) {
    return sentences.map((e) => e.length).fold(0, sum);
  }
}

class SentenceIndex {
  final GCursor position;
  final int length;

  SentenceIndex(this.position, Sentence sentence)
      : length = sentence.numberOfWordMatches;
}

class GCursor {
  final int cursor;

  GCursor(this.cursor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GCursor &&
          runtimeType == other.runtimeType &&
          cursor == other.cursor;

  @override
  int get hashCode => cursor.hashCode;

  @override
  String toString() {
    return 'GCursor{cursor: $cursor}';
  }

  GCursor plus(int n) {
    return GCursor(cursor + n);
  }
}
