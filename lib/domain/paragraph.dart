import 'package:flyt/domain/sentence.dart';

class Paragraph {
  final List<Sentence> _sentences;
  static final RegExp _sentenceMatcher = new RegExp(r"([\w\s',:]+\S+)");

  Paragraph(rawText) : _sentences = mapToSentences(rawText);

  static List<Sentence> mapToSentences(String _rawText) {
    return _splitSentences(_rawText)
        .map((e) => _rawText.substring(e.start, e.end).trim())
        .toList()
        .map((e) => Sentence(e))
        .toList();
  }

  List<String> get tokenizedWords =>
      _sentences.expand((sentence) => sentence.words).toList();

  List<String> get rawSentences =>
      _sentences.map((sentence) => sentence.rawText).toList();

  static Iterable<RegExpMatch> _splitSentences(String rawText) {
    return _sentenceMatcher.allMatches(rawText);
  }
}
