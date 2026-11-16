import 'book.dart';

class ReadingList {
  final String id;
  String name;
  final List<Book> books;

  ReadingList({
    required this.id,
    required this.name,
    List<Book>? books,
  }) : books = books ?? [];

  bool containsBook(String bookId) => books.any((b) => b.bookId == bookId);
}