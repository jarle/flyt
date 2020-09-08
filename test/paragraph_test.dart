import 'package:flutter_test/flutter_test.dart';
import 'package:flyt/domain/paragraph.dart';

void main() {
  test("should split sentences correctly on periods", () {
    var paragraph =
        Paragraph("First sentence. Second sentence.. Third sentence...");

    expect(paragraph.sentences, [
      "First sentence.",
      "Second sentence..",
      "Third sentence...",
    ]);

    expect(paragraph.words, [
      "First",
      "sentence.",
      "Second",
      "sentence..",
      "Third",
      "sentence...",
    ]);
  });

  test("should split sentences correctly on newlines", () {
    var paragraph =
        Paragraph("First sentence.\nSecond sentence..\nThird sentence...\n");

    expect(paragraph.sentences, [
      "First sentence.",
      "Second sentence..",
      "Third sentence...",
    ]);

    expect(paragraph.words, [
      "First",
      "sentence.",
      "Second",
      "sentence..",
      "Third",
      "sentence...",
    ]);
  });

  test("should split sentences correctly on question marks", () {
    var paragraph =
        Paragraph("First sentence? Second sentence?? Third sentence???");

    expect(paragraph.sentences, [
      "First sentence?",
      "Second sentence??",
      "Third sentence???",
    ]);

    expect(paragraph.words, [
      "First",
      "sentence?",
      "Second",
      "sentence??",
      "Third",
      "sentence???",
    ]);
  });

  test("should split sentences correctly on mixed punctuation", () {
    var paragraph = Paragraph(
        "First sentence!!!?..\nSecond sentence?...!!!? Third sentence???");

    expect(paragraph.sentences, [
      "First sentence!!!?..",
      "Second sentence?...!!!?",
      "Third sentence???",
    ]);

    expect(paragraph.words, [
      "First",
      "sentence!!!?..",
      "Second",
      "sentence?...!!!?",
      "Third",
      "sentence???",
    ]);
  });

  test("should handle quotations properly", () {
    var paragraph = Paragraph(
        "\"It's a matter of splitting lines correctly into words\", he said.");

    expect(paragraph.sentences,
        ["\"It's a matter of splitting lines correctly into words\", he said."],
        skip: true); //TODO

    expect(paragraph.words, [
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
    ]);
  });
}
