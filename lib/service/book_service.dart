import '../model/book.dart';

class BookService {
  final List<Book> _books;

  BookService({List<Book>? books}) : _books = List.of(books ?? []);

  List<Book> getAllBooks() => List.unmodifiable(_books);

  Book? getBookById(String bookId) {
    for (final book in _books) {
      if (book.bookId == bookId) return book;
    }
    return null;
  }
}
