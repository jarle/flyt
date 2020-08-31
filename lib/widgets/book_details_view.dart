import 'package:flutter/material.dart';
import 'package:flyt/services/book_reader_service.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_reader.book.title),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Text("${_reader.book.title} by ${_reader.book.author}")
            ),
            Expanded(
              child: Text("At word ${_reader.cursorPosition}")
            ),
          ],
        )
      ),
    );
  }

}
