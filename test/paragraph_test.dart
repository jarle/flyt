import 'package:flutter_test/flutter_test.dart';
import 'package:flyt/domain/paragraph.dart';

void main() {
  test(
    "should split sentences correctly on periods",
    () {
      var paragraph = Paragraph(
        "First sentence. Second sentence.. Third sentence...",
      );

      expect(
        paragraph.rawSentences,
        [
          "First sentence.",
          "Second sentence..",
          "Third sentence...",
        ],
      );

      expect(
        paragraph.tokenizedWords,
        [
          "First",
          "sentence.",
          "Second",
          "sentence..",
          "Third",
          "sentence...",
        ],
      );
    },
  );

  test(
    "should split sentences correctly on newlines",
    () {
      var paragraph = Paragraph(
        "First sentence.\nSecond sentence..\nThird sentence...\n",
      );

      expect(
        paragraph.rawSentences,
        [
          "First sentence.",
          "Second sentence..",
          "Third sentence...",
        ],
      );

      expect(
        paragraph.tokenizedWords,
        [
          "First",
          "sentence.",
          "Second",
          "sentence..",
          "Third",
          "sentence...",
        ],
      );
    },
  );

  test(
    "should split sentences correctly on question marks",
    () {
      var paragraph = Paragraph(
        "First sentence? Second sentence?? Third sentence???",
      );

      expect(
        paragraph.rawSentences,
        [
          "First sentence?",
          "Second sentence??",
          "Third sentence???",
        ],
      );

      expect(
        paragraph.tokenizedWords,
        [
          "First",
          "sentence?",
          "Second",
          "sentence??",
          "Third",
          "sentence???",
        ],
      );
    },
  );

  test(
    "should split sentences correctly on mixed punctuation",
    () {
      var paragraph = Paragraph(
        "First sentence!!!?..\nSecond sentence?...!!!? Third sentence???",
      );

      expect(
        paragraph.rawSentences,
        [
          "First sentence!!!?..",
          "Second sentence?...!!!?",
          "Third sentence???",
        ],
      );

      expect(
        paragraph.tokenizedWords,
        [
          "First",
          "sentence!!!?..",
          "Second",
          "sentence?...!!!?",
          "Third",
          "sentence???",
        ],
      );
    },
  );

  test(
    "should handle quotations properly",
    () {
      var paragraph = Paragraph(
        "\"It's a matter of splitting lines correctly into sentences\", he said.",
      );

      expect(
        paragraph.rawSentences,
        [
          "\"It's a matter of splitting lines correctly into sentences\", he said.",
        ],
        skip: true, //TODO: commas are interpreted as new sentences
      );
    },
  );
}
