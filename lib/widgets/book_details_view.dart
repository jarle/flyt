import 'package:flutter/material.dart';
import 'package:flyt/services/book_indexing_service.dart';
import 'package:flyt/services/book_reader_service.dart';
import 'package:flyt/widgets/speed_reader_view.dart';

class BookDetailsView extends StatefulWidget {
  final BookReaderService _reader;

  BookDetailsView(this._reader);

  @override
  _BookDetailsViewState createState() => _BookDetailsViewState(_reader);
}

class _BookDetailsViewState extends State<BookDetailsView> {
  BookReaderService _reader;

  _BookDetailsViewState(this._reader);

  @override
  void initState() {
    super.initState();
    indexBook();
  }

  void indexBook() async {
    await _reader.loadContent();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book details"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(8),
            children: [
              Container(
                margin: EdgeInsets.all(8),
                child: Text(
                  _reader.book.title,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Center(
                  child: Text(
                    "${_reader.bookProgress().toStringAsFixed(0)}%",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ),
              ),
              ..._reader.bookIndex.chapters.map(toListTile).toList()
            ],
          ),
        )
      ],
    );
  }

  Widget toListTile(ChapterIndex chapter) {
    final bool isCurrentChapter = _reader.currentChapter() == chapter;
    final postfix = isCurrentChapter
        ? " (${_reader.chapterProgress().toStringAsFixed(0)}%)"
        : "";
    var text = "${chapter.title}$postfix";

    return Card(
      child: ListTile(
        title: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyText1.copyWith(
                color: isCurrentChapter
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.bodyText1.color,
              ),
        ),
        onTap: () => launchChapter(chapter.position),
      ),
    );
  }

  launchChapter(GCursor position) {
    final bool isNewChapter = (_reader.currentChapter() !=
        _reader.bookIndex.currentChapter(position));

    if (isNewChapter) {
      _reader.moveCursorTo(position.cursor);
    }

    _readBook(_reader);
  }

  _readBook(BookReaderService reader) async {
    reader.loadContent().then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return SpeedReaderView(reader);
              },
            ),
          ),
        );
  }
}
