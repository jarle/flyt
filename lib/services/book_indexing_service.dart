import 'package:flyt/domain/book_chapter.dart';

class BookIndexingService {
  final List<BookChapter> chapters;
  BookIndexingService(this.chapters);


}

class CPSWCursor {
  final int chapter;
  final int paragraph;
  final int sentence;
  final int word;

  CPSWCursor(this.chapter, this.paragraph, this.sentence, this.word);
}
