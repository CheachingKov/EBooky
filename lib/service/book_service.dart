import '../data/book_data.dart';
import '../model/book.dart';
import '../model/book_category.dart';

class BookService {
  final List<Book> _books;

  BookService({List<Book>? books}) : _books = List.of(books ?? sampleBooks);

  // 1. Browse All Books
  List<Book> getAllBooks() {
    return List.unmodifiable(_books);
  }

  // 2. View Book Details by ID
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

  // View Book Details by Title
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

  // 3. Search Books by Title or Author
  // If no match is found, returns an empty list [] so UI can show "Book not found"
  List<Book> searchBooks(String query) {
    var trimmedQuery = query.trim().toLowerCase();

    if (trimmedQuery.isEmpty) {
      return getAllBooks();
    }

    List<Book> results = [];
    for (var book in _books) {
      var titleMatches = book.title.toLowerCase().contains(trimmedQuery);
      var authorMatches = book.author.toLowerCase().contains(trimmedQuery);

      if (titleMatches || authorMatches) {
        results.add(book);
      }
    }

    return List.unmodifiable(results);
  }

  // 4. Filter by Genre
  List<Book> getBooksByGenre(String genre) {
    var trimmedGenre = genre.trim().toLowerCase();

    if (trimmedGenre.isEmpty || trimmedGenre == 'all') {
      return getAllBooks();
    }

    List<Book> results = [];
    for (var book in _books) {
      if (book.genre.toLowerCase() == trimmedGenre) {
        results.add(book);
      }
    }

    return List.unmodifiable(results);
  }

  // 5. Filter by Book Category / Type
  List<Book> getBooksByType(BookCategory bookType) {
    List<Book> results = [];
    for (var book in _books) {
      if (book.bookType == bookType) {
        results.add(book);
      }
    }

    return List.unmodifiable(results);
  }

  // 6. Browse All Genres
  List<String> getAllGenres() {
    List<String> genres = [];
    for (var book in _books) {
      var g = book.genre.trim();
      if (g.isNotEmpty && !genres.contains(g)) {
        genres.add(g);
      }
    }
    genres.sort();
    return List.unmodifiable(genres);
  }

  // 7. Browse All Book Types
  List<BookCategory> getAllBookTypes() {
    return BookCategory.values;
  }
}
