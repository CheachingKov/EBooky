import '../data/book_data.dart';
import '../model/book.dart';
import '../model/book_genre.dart';

class BookService {
  final List<Book> _books;

  BookService({List<Book>? books}) : _books = List.of(books ?? sampleBooks);

  List<Book> getAllBooks() {
    return List.unmodifiable(_books);
  }

  Book? getBookById(String bookId) {
    var trimmedId = bookId.trim();
    if (trimmedId.isEmpty) {
      return null;
    }

    for (var book in _books) {
      if (book.bookId == trimmedId) {
        return book;
      }
    }
    return null;
  }

  Book? getBookByTitle(String title) {
    var trimmedTitle = title.trim().toLowerCase();
    if (trimmedTitle.isEmpty) {
      return null;
    }

    for (var book in _books) {
      if (book.title.toLowerCase() == trimmedTitle) {
        return book;
      }
    }
    return null;
  }

  List<Book> searchBooks(String query) {
    var trimmedQuery = query.trim().toLowerCase();

    if (trimmedQuery.isEmpty) {
      return getAllBooks();
    }

    List<Book> results = [];
    for (var book in _books) {
      var titleMatches = book.title.toLowerCase().contains(trimmedQuery);
      var authorMatches = book.author.toLowerCase().contains(trimmedQuery);
      var genreMatches = book.genre.name.toLowerCase().contains(trimmedQuery);

      if (titleMatches || authorMatches || genreMatches) {
        results.add(book);
      }
    }

    return List.unmodifiable(results);
  }

  List<Book> getBooksByGenre(BookGenre genre) {
    List<Book> results = [];
    for (var book in _books) {
      if (book.genre == genre) {
        results.add(book);
      }
    }

    return List.unmodifiable(results);
  }

  List<BookGenre> getAllGenres() {
    return BookGenre.values;
  }
}
