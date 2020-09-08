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

  test("should split sentences with special characters", () {
    var paragraph = Paragraph(
        "Don't worry about the special signs; they should be handled properly.");

    expect(paragraph.sentences, [
      "Don't worry about the special signs;",
      "they should be handled properly."
    ]);

    expect(paragraph.words, [
      "Don't",
      "worry",
      "about",
      "the",
      "special",
      "signs;",
      "they",
      "should",
      "be",
      "handled",
      "properly."
    ]);
  });
}
