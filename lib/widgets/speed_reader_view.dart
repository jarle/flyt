import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flyt/services/book_reader_service.dart';

class SpeedReaderView extends StatefulWidget {
  final BookReaderService _readerService;

  SpeedReaderView(this._readerService);

  @override
  _SpeedReaderViewState createState() => _SpeedReaderViewState(_readerService);
}

class _SpeedReaderViewState extends State<SpeedReaderView> {
  final BookReaderService _bookReader;
  Timer timer;
  String _currentWord = "";
  bool _isReading = false;

  _SpeedReaderViewState(this._bookReader);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      this._currentWord = _bookReader.current();
    });
  }

  Timer createTimer() {
    // TODO: this logic should (probably) not be in view layer
    return Timer.periodic(new Duration(milliseconds: 110), (timer) async {
      setState(() {
        this._currentWord = this._bookReader.next();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton actionButton = _isReading
        ? readingFloatingActionButton()
        : playingFloatingActionButton();

    return Scaffold(
      appBar: AppBar(
        title: Text(_bookReader.book.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: handlePopupMenuClick,
            itemBuilder: (BuildContext context) {
              return {'Set position'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: body(),
      floatingActionButton: actionButton,
    );
  }

  void handlePopupMenuClick(String value) async {
    switch (value) {
      case 'Set position':
        break;
    }
  }

  Widget body() {
    return Padding(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            Visibility(
              replacement: Expanded(flex: 2, child: Container()),
              visible: !_isReading,
              child: Expanded(
                flex: 2,
                child: GestureDetector(
                    child: Text(_bookReader.above(),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade),
                    onTap: () {
                      skip(-100);
                    },
                    onDoubleTap: () {
                      skip(-500);
                    }),
              ),
            ),
            Expanded(
              child: currentWordWidget(),
            ),
            Visibility(
                replacement: Expanded(flex: 2, child: Container()),
                visible: !_isReading,
                child: Expanded(
                  flex: 2,
                  child: GestureDetector(
                    child: Text(_bookReader.below(),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.justify),
                    onTap: () {
                      skip(100);
                    },
                    onDoubleTap: () {
                      skip(500);
                    },
                  ),
                ))
          ],
        ));
  }

  Widget currentWordWidget() {
    var length = _currentWord.length;
    var midpoint = max((length / 2).floor() - 1, 0);
    var before = _currentWord.substring(0, midpoint);
    var focus = _currentWord.substring(midpoint, midpoint + 1);
    var after = _currentWord.substring(midpoint + 1);

    var focusedTextStyle = Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 32);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(before, style: focusedTextStyle),
              ],
            )),
        Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        style: focusedTextStyle,
                        children: [
                      TextSpan(
                          text: focus,
                          style: focusedTextStyle.copyWith(
                              color: Colors.redAccent)),
                      TextSpan(text: after)
                    ])),
              ],
            )),
      ],
    );
  }

  FloatingActionButton playingFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _toggleReading,
      tooltip: 'Start reading ${_bookReader.book.title}',
      child: Icon(Icons.play_arrow),
    );
  }

  FloatingActionButton readingFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _toggleReading,
      tooltip: 'Pause reading ${_bookReader.book.title}',
      child: Icon(Icons.pause),
    );
  }

  void _toggleReading() async {
    timer?.cancel();
    if (_isReading) {
      await pauseReading();
    } else {
      await resumeReading();
    }

    setState(() {
      _isReading = !_isReading;
    });
  }

  Future resumeReading() async {
    timer = createTimer();
  }

  Future pauseReading() async {
    await _bookReader.updateCursorPosition();
  }

  @override
  void dispose() async {
    super.dispose();
    timer?.cancel();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await pauseReading();
  }

  skip(int wordsToSkip) {
    this._bookReader.skip(wordsToSkip);
    setState(() {
      this._currentWord = this._bookReader.current();
    });
  }
}
