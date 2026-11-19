import '../model/book.dart';
import '../model/reading_list.dart';
import 'book_service.dart';

class ReadingListService {
  final BookService _bookService;
  final List<ReadingList> _readingLists;
  int _nextId = 1;

  ReadingListService({
    required BookService bookService,
    List<ReadingList>? initialLists,
  })  : _bookService = bookService,
        _readingLists = List.of(initialLists ?? []) {
    for (var list in _readingLists) {
      if (list.id.startsWith('rl-')) {
        var numPart = int.tryParse(list.id.substring(3));
        if (numPart != null && numPart >= _nextId) {
          _nextId = numPart + 1;
        }
      }
    }
  }

  ReadingList createReadingList(String name, [String description = '']) {
    var trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Reading list name cannot be empty');
    }

    if (trimmedName.length > 50) {
      throw ArgumentError('Reading list name cannot exceed 50 characters');
    }

    for (var list in _readingLists) {
      if (list.name.toLowerCase() == trimmedName.toLowerCase()) {
        throw ArgumentError('A reading list with this name already exists');
      }
    }

    var newList = ReadingList(
      id: 'rl-$_nextId',
      name: trimmedName,
      description: description.trim(),
    );
    _nextId++;

    _readingLists.add(newList);
    return newList;
  }

  List<ReadingList> getAllReadingLists() {
    return List.unmodifiable(_readingLists);
  }

  ReadingList? getReadingListById(String listId) {
    var trimmedId = listId.trim();
    if (trimmedId.isEmpty) {
      return null;
    }

    for (var list in _readingLists) {
      if (list.id == trimmedId) {
        return list;
      }
    }
    return null;
  }

  ReadingList? getReadingListByName(String name) {
    var trimmedName = name.trim().toLowerCase();
    if (trimmedName.isEmpty) {
      return null;
    }

    for (var list in _readingLists) {
      if (list.name.toLowerCase() == trimmedName) {
        return list;
      }
    }
    return null;
  }

  ReadingList renameReadingList(
    String listId,
    String newName, [
    String? newDescription,
  ]) {
    var list = _requireReadingList(listId);

    var trimmedName = newName.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Reading list name cannot be empty');
    }

    if (trimmedName.length > 50) {
      throw ArgumentError('Reading list name cannot exceed 50 characters');
    }

    for (var otherList in _readingLists) {
      if (otherList.id != listId &&
          otherList.name.toLowerCase() == trimmedName.toLowerCase()) {
        throw ArgumentError('A reading list with this name already exists');
      }
    }

    list.name = trimmedName;
    if (newDescription != null) {
      list.description = newDescription.trim();
    }
    list.updatedAt = DateTime.now();

    return list;
  }

  bool deleteReadingList(String listId) {
    for (int i = 0; i < _readingLists.length; i++) {
      if (_readingLists[i].id == listId) {
        _readingLists.removeAt(i);
        return true;
      }
    }
    return false;
  }

  bool addBookToList(String listId, String bookId) {
    var list = _requireReadingList(listId);

    var book = _bookService.getBookById(bookId);
    if (book == null) {
      throw ArgumentError.value(bookId, 'bookId', 'Book does not exist');
    }

    if (list.containsBook(bookId)) {
      return false;
    }

    list.addBook(book);
    return true;
  }

  bool removeBookFromList(String listId, String bookId) {
    var list = _requireReadingList(listId);

    if (!list.containsBook(bookId)) {
      return false;
    }

    return list.removeBook(bookId);
  }

  List<Book> getListBooks(
    String listId, [
    ReadingListSortOrder sortOrder = ReadingListSortOrder.alphabetical,
  ]) {
    var list = _requireReadingList(listId);

    List<Book> books = List.of(list.books);

    if (sortOrder == ReadingListSortOrder.alphabetical) {
      books.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (sortOrder == ReadingListSortOrder.newest) {
      books = books.reversed.toList();
    } else if (sortOrder == ReadingListSortOrder.oldest) {
      books = List.of(books);
    }

    return List.unmodifiable(books);
  }

  List<ReadingList> getReadingListsForBook(String bookId) {
    List<ReadingList> matchingLists = [];
    for (var list in _readingLists) {
      if (list.containsBook(bookId)) {
        matchingLists.add(list);
      }
    }
    return List.unmodifiable(matchingLists);
  }

  List<ReadingList> searchReadingLists(String query) {
    var trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isEmpty) {
      return getAllReadingLists();
    }

    List<ReadingList> results = [];
    for (var list in _readingLists) {
      if (list.name.toLowerCase().contains(trimmedQuery)) {
        results.add(list);
      }
    }
    return List.unmodifiable(results);
  }

  ReadingList _requireReadingList(String listId) {
    var list = getReadingListById(listId);
    if (list == null) {
      throw StateError('Reading list "$listId" does not exist');
    }
    return list;
  }
}
