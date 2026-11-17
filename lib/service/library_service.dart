
import '../model/library_item.dart';
import '../model/reading_list.dart';
import '../model/reading_status.dart';
import 'book_service.dart';

class LibraryService {
  final BookService _bookService;

  final List<LibraryItem> _libraryItems = [];
  final List<ReadingList> _readingLists = [];

  int _nextReadingListId = 1;

  LibraryService({required BookService bookService})
      : _bookService = bookService;

  // Get all library items.
  List<LibraryItem> getLibraryItems() =>
      List.unmodifiable(_libraryItems);

  // Get all reading lists.
  List<ReadingList> getReadingLists() =>
      List.unmodifiable(_readingLists);

  // Add a book to the user's library.
  LibraryItem addToLibrary(String bookId) {
    final existingItem = _findLibraryItem(bookId);

    if (existingItem != null) {
      return existingItem;
    }

    final book = _bookService.getBookById(bookId);

    if (book == null) {
      throw ArgumentError.value(
        bookId,
        'bookId',
        'Book does not exist',
      );
    }

    final item = LibraryItem(book: book);
    _libraryItems.add(item);

    return item;
  }

  // Remove a book from the user's library.
  bool removeFromLibrary(String bookId) {
    final item = _findLibraryItem(bookId);

    if (item == null) {
      return false;
    }

    return _libraryItems.remove(item);
  }

  // Update a book's reading status.
  void updateReadingStatus(
    String bookId,
    ReadingStatus status,
  ) {
    final item = _requireLibraryItem(bookId);
    item.status = status;
  }

  // Toggle a book's favorite status.
  bool toggleFavorite(String bookId) {
    final item = _requireLibraryItem(bookId);

    item.isFavorite = !item.isFavorite;

    return item.isFavorite;
  }

  // Create a custom reading list.
  ReadingList createReadingList(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError(
        'Reading list name cannot be empty',
      );
    }

    final duplicateName = _readingLists.any(
      (list) =>
          list.name.toLowerCase() ==
          trimmedName.toLowerCase(),
    );

    if (duplicateName) {
      throw ArgumentError(
        'A reading list with this name already exists',
      );
    }

    final list = ReadingList(
      id: 'reading-list-${_nextReadingListId++}',
      name: trimmedName,
    );

    _readingLists.add(list);

    return list;
  }

  // Add a book to a reading list.
  void addBookToList(String listId, String bookId) {
    final list = _requireReadingList(listId);

    final book = _bookService.getBookById(bookId);

    if (book == null) {
      throw ArgumentError.value(
        bookId,
        'bookId',
        'Book does not exist',
      );
    }

    if (!list.containsBook(bookId)) {
      list.books.add(book);
    }
  }

  // Remove a book from a reading list.
  bool removeBookFromList(String listId, String bookId) {
    final list = _requireReadingList(listId);

    final bookIndex = list.books.indexWhere(
      (book) => book.bookId == bookId,
    );

    if (bookIndex == -1) {
      return false;
    }

    list.books.removeAt(bookIndex);

    return true;
  }

  // Find a library item or throw an exception.
  LibraryItem _requireLibraryItem(String bookId) {
    final item = _findLibraryItem(bookId);

    if (item == null) {
      throw StateError(
        'Book "$bookId" is not in the library',
      );
    }

    return item;
  }

  // Find a library item without throwing an exception.
  LibraryItem? _findLibraryItem(String bookId) {
    for (final item in _libraryItems) {
      if (item.book.bookId == bookId) {
        return item;
      }
    }

    return null;
  }

  // Find a reading list or throw an exception.
  ReadingList _requireReadingList(String listId) {
    for (final list in _readingLists) {
      if (list.id == listId) {
        return list;
      }
    }

    throw StateError(
      'Reading list "$listId" does not exist',
    );
  }
}
