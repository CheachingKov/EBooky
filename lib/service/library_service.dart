import '../model/book.dart';
import '../model/library_item.dart';
import '../model/reading_status.dart';
import 'book_service.dart';

class LibraryService {
  final BookService _bookService;

  final List<LibraryItem> _libraryItems = [];

  LibraryService({required BookService bookService})
      : _bookService = bookService;

  List<LibraryItem> getLibraryItems() {
    return List.unmodifiable(_libraryItems);
  }

  List<Book> getBooks() {
    List<Book> books = [];
    for (var item in _libraryItems) {
      books.add(item.book);
    }
    return books;
  }

  bool containsBook(String bookId) {
    for (var item in _libraryItems) {
      if (item.book.bookId == bookId) {
        return true;
      }
    }
    return false;
  }

  LibraryItem addBook(String bookId, [ReadingStatus? status]) {
    var existingItem = _findLibraryItem(bookId);
    if (existingItem != null) {
      return existingItem;
    }

    var book = _bookService.getBookById(bookId);
    if (book == null) {
      throw ArgumentError.value(bookId, 'bookId', 'Book does not exist');
    }

    var item = LibraryItem(
      book: book,
      status: status ?? ReadingStatus.unread,
    );
    _libraryItems.add(item);
    return item;
  }

  LibraryItem addToLibrary(String bookId) {
    return addBook(bookId);
  }

  bool removeBook(String bookId) {
    var item = _findLibraryItem(bookId);
    if (item == null) {
      return false;
    }
    return _libraryItems.remove(item);
  }

  bool removeFromLibrary(String bookId) {
    return removeBook(bookId);
  }

  void updateReadingStatus(String bookId, ReadingStatus status) {
    var item = _requireLibraryItem(bookId);
    item.status = status;
  }

  bool toggleFavorite(String bookId) {
    var item = _requireLibraryItem(bookId);
    item.isFavorite = !item.isFavorite;
    return item.isFavorite;
  }

  List<Book> getFavoriteBooks() {
    List<Book> favorites = [];
    for (var item in _libraryItems) {
      if (item.isFavorite) {
        favorites.add(item.book);
      }
    }
    return List.unmodifiable(favorites);
  }

  List<LibraryItem> filterByStatus(ReadingStatus status) {
    List<LibraryItem> filtered = [];
    for (var item in _libraryItems) {
      if (item.status == status) {
        filtered.add(item);
      }
    }
    return List.unmodifiable(filtered);
  }

  List<Book> getBooksByStatus(ReadingStatus status) {
    List<Book> books = [];
    for (var item in _libraryItems) {
      if (item.status == status) {
        books.add(item.book);
      }
    }
    return List.unmodifiable(books);
  }

  LibraryItem _requireLibraryItem(String bookId) {
    var item = _findLibraryItem(bookId);
    if (item == null) {
      throw StateError('Book "$bookId" is not in the library');
    }
    return item;
  }

  LibraryItem? _findLibraryItem(String bookId) {
    for (var item in _libraryItems) {
      if (item.book.bookId == bookId) {
        return item;
      }
    }
    return null;
  }
}
