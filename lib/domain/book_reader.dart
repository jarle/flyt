import 'package:flyt/domain/book.dart';
import 'package:flyt/util/UUID.dart';

class BookReader {
  final Identifier _id;
  final Book _book;
  int cursorPosition = 0;

  BookReader(this._book, this._id, { cursorPosition = 0 });

  get book => _book;

  Identifier get id => _id;

  int nextPosition() {
    return cursorPosition++;
  }

  @override
  String toString() {
    return 'BookReader{_id: $_id, _book: $_book, cursorPosition: $cursorPosition}';
  }

  void backward() {
    cursorPosition--;
  }

  void forward() {
    cursorPosition++;
  }

  void skip(int wordsToSkip) {
    cursorPosition = cursorPosition + wordsToSkip; //TODO: test
  }

  void setPosition(int newPosition) {
    cursorPosition = newPosition;
  }
}