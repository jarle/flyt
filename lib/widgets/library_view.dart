import 'dart:developer' as developer;
import 'dart:io';

import 'package:epub/epub.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flyt/domain/book.dart';
import 'package:flyt/services/book_reader_service.dart';
import 'package:flyt/model/model.dart';
import 'package:flyt/services/library_service.dart';
import 'package:flyt/widgets/speed_reader_view.dart';

import 'book_details_view.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final BookLibraryService _library = BookLibraryService();

  @override
  void initState() {
    super.initState();
    developer.log("Initializing database");
    BookLibraryModel().initializeDB().then((bool success) {
      if (success) {
        developer.log("Initializing library state");
        _library.initState().then((value) {
          setState(() {});
          developer.log(
              "Library state successfully initialized with ${_library.bookReaders.length} book readers");
        });
      } else {
        throw "Unable to initialize database";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FLYT')),
      body: libraryWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBookToLibrary,
        tooltip: 'Add book to library',
        child: Icon(Icons.library_add),
      ),
    );
  }

  ListView libraryWidget() => ListView(
        children: _library.bookReaders.map(_buildRow).toList(),
      );

  ListTile _buildRow(BookReaderService reader) => ListTile(
        title: Text("${reader.book.title}"),
        subtitle: Text(reader.book.author),
        trailing: RaisedButton(
          onPressed: () => _readBook(reader),
          shape: StadiumBorder(),
          child: Icon(Icons.play_arrow),
        ),
        onTap: () => _openBookDetails(reader),
        onLongPress: () async => await _library.clearDatabase().then((value) {
          setState(() {});
        }),
      );

  Future<void> _addBookToLibrary() async {
    File _bookFile = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ["epub"]);

    if (_bookFile == null) {
      return;
    }

    final List<int> bytes = await _bookFile.readAsBytes();
    final EpubBook _epubBook = await EpubReader.readBook(bytes);

    return _library
        .addNewBook(Book(
            _bookFile, _epubBook.Title.toString(), _epubBook.Author.toString()))
        .then((value) {
      setState(() {});
    });
  }

  _openBookDetails(BookReaderService reader) async {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return BookDetailsView(reader);
      },
    ));
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
