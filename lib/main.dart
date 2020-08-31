import 'package:flutter/material.dart';

import 'widgets/library_view.dart';

void main() {
  runApp(SpeedReaderApp());
}

class SpeedReaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLYT',
      home: LibraryView(),
      darkTheme: ThemeData.dark()
    );
  }
}
