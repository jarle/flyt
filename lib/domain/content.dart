class Content {
  List<String> _content;

  Content([this._content]);

  int get length => content().length;

  List<String> content() {
    // yuck
    if (_content == null) {
      throw ContentNotLoadedException();
    }

    return _content;
  }
}

class ContentNotLoadedException implements Exception {}
