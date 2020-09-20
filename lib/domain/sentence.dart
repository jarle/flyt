class Sentence {
  final String _rawText;
  final Iterable<RegExpMatch> _wordMatches;
  static final RegExp _wordMatcher = new RegExp(r"(\S+)");

  String get rawText => _rawText;

  Sentence(this._rawText): _wordMatches = _splitWords(_rawText);

  List<String> get words => _wordMatches.map((e) => _rawText.substring(e.start, e.end).trim()).toList();

  get numberOfWordMatches => _wordMatches.length;

  static Iterable<RegExpMatch> _splitWords(String rawText) {
    return _wordMatcher.allMatches(rawText);
  }
}
