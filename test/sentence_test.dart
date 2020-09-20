import 'package:flutter_test/flutter_test.dart';
import 'package:flyt/domain/sentence.dart';

void main() {
  test(
    "should split words correctly on periods",
    () {
      var sentence = Sentence(
        "First sentence. Second sentence.. Third sentence...",
      );

      expect(
        sentence.words,
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
    "should handle quotations properly",
    () {
      var sentence = Sentence(
        "\"It's a matter of splitting lines correctly into words\", he said.",
      );

      expect(
        sentence.words,
        [
          "\"It's",
          "a",
          "matter",
          "of",
          "splitting",
          "lines",
          "correctly",
          "into",
          "words\",",
          "he",
          "said."
        ],
      );
    },
  );
}
