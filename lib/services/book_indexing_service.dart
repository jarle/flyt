import 'package:flyt/domain/book_chapter.dart';
import 'package:flyt/domain/paragraph.dart';

class BookIndexingService {
  final List<BookChapter> chapters;

  BookIndexingService(this.chapters);

  BookIndex indexBook() {
    return chapters.fold(BookIndex([]), foldChapter);
  }

  static BookIndex foldChapter(BookIndex currentIndex, BookChapter newChapter) {
    return BookIndex(
        [...currentIndex.chapters, indexChapter(currentIndex, newChapter)]);
  }

  static ChapterIndex indexChapter(
      BookIndex currentIndex, BookChapter newChapter) {
    return newChapter.paragraphs
        .fold(ChapterIndex(GCursor(currentIndex.length), []), foldParagraph);
  }

  static ChapterIndex foldParagraph(
      ChapterIndex currentChapter, Paragraph newParagraph) {
    return ChapterIndex(currentChapter.position, [
      ...currentChapter.paragraphs,
      indexParagraph(currentChapter, newParagraph)
    ]);
  }

  static ParagraphIndex indexParagraph(
      ChapterIndex currentChapter, Paragraph newParagraph) {
    return newParagraph.rawSentences
        .fold(ParagraphIndex(GCursor(currentChapter.length), []), foldSentence);
  }

  static ParagraphIndex foldSentence(
      ParagraphIndex currentParagraph, String rawSentence) {
    return ParagraphIndex(currentParagraph.position, [
      ...currentParagraph.sentences,
      SentenceIndex(GCursor(currentParagraph.length), rawSentence.length)
      // TODO: actual tokenization
    ]);
  }
}

class BookIndex {
  final List<ChapterIndex> chapters;
  final int length;

  BookIndex(this.chapters) : length = calculateLength(chapters);

  static int calculateLength(List<ChapterIndex> chapters) {
    return chapters.map((e) => e.length).reduce(sum);
  }
}

int sum(value, element) => value + element;

class ChapterIndex {
  final GCursor position;
  final List<ParagraphIndex> paragraphs;
  final int length;

  ChapterIndex(this.position, this.paragraphs)
      : length = calculateLength(paragraphs);

  static int calculateLength(List<ParagraphIndex> sentences) {
    return sentences.map((e) => e.length).reduce(sum);
  }
}

class ParagraphIndex {
  final GCursor position;
  final List<SentenceIndex> sentences;
  final int length;

  ParagraphIndex(this.position, this.sentences)
      : length = calculateLength(sentences);

  static int calculateLength(List<SentenceIndex> sentences) {
    return sentences.map((e) => e.length).reduce(sum);
  }
}

class SentenceIndex {
  final GCursor position;
  final int length;

  SentenceIndex(this.position, this.length);
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
}
