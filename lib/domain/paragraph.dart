import 'package:flyt/domain/sentence.dart';

class Paragraph {
  final List<Sentence> _sentences;
  static final RegExp _sentenceMatcher = new RegExp(r"([\w\s',:]+\S+)");

  Paragraph(rawText) : _sentences = mapToSentences(rawText);

  List<Sentence> get sentences => _sentences;

  static List<Sentence> mapToSentences(String _rawText) {
    return _splitSentences(_rawText)
        .map(
          (sentenceMatch) =>
              _rawText.substring(sentenceMatch.start, sentenceMatch.end).trim(),
        )
        .toList()
        .map((rawSentence) => Sentence(rawSentence))
        .toList();
  }

  List<String> get tokenizedWords => _sentences
      .expand(
        (sentence) => sentence.words,
      )
      .toList();

  List<String> get rawSentences => _sentences
      .map(
        (sentence) => sentence.rawText,
      )
      .toList();

  static Iterable<RegExpMatch> _splitSentences(String rawText) {
    return _sentenceMatcher.allMatches(rawText);
  }
}
