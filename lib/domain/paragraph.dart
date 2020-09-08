class Paragraph {
  final String _rawText;
  final Iterable<RegExpMatch> _sentenceMatches;
  final Iterable<RegExpMatch> _wordMatches;
  static final RegExp _sentenceMatcher = new RegExp(r"([\w\s',:]+\S+)");
  static final RegExp _wordMatcher = new RegExp(r"(\S+)");

  Paragraph(this._rawText): _sentenceMatches = _splitSentences(_rawText), _wordMatches = _splitWords(_rawText);

  List<String> get words => _wordMatches.map((e) => _rawText.substring(e.start, e.end).trim()).toList();

  List<String> get sentences => _sentenceMatches.map((e) => _rawText.substring(e.start, e.end).trim()).toList();

  static Iterable<RegExpMatch> _splitSentences(String rawText) {
    return _sentenceMatcher.allMatches(rawText);
  }

  static Iterable<RegExpMatch> _splitWords(String rawText) {
    return _wordMatcher.allMatches(rawText);
  }
}
