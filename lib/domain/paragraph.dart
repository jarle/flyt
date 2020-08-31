class Paragraph {
  final List<String> sentences;

  Paragraph(this.sentences);

  get text => sentences.join("\n");
}