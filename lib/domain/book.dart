import 'dart:io';

class Book {
  final File file;
  final String title;
  final String author;

  Book(this.file, this.title, this.author);

  @override
  String toString() {
    return 'Book{file: $file, title: $title, author: $author}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          title == other.title &&
          author == other.author;

  @override
  int get hashCode => file.hashCode ^ title.hashCode ^ author.hashCode;
}