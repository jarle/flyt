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
        Container(
          child: Text(_reader.book.title,
              style: Theme.of(context).textTheme.headline5),
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.all(8),
          children: [..._reader.bookIndex.chapters.map(toListTile).toList()],
        ))
      ],
    );
  }

  Widget toListTile(ChapterIndex chapter) => ListTile(
        title:
            Text(chapter.title, style: Theme.of(context).textTheme.bodyText1),
        onTap: () => launchChapter(chapter.position),
      );

  launchChapter(GCursor position) {
    _reader.moveCursorTo(position.cursor);
    _readBook(_reader);
  }

  _readBook(BookReaderService reader) async {
    reader
        .loadContent()
        .then((value) => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return SpeedReaderView(reader);
              },
            )));
  }
}
