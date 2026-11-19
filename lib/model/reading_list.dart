import 'book.dart';

enum ReadingListSortOrder {
  alphabetical, 
  newest,  
  oldest,
}

class ReadingList {
  final String id;
  String name;
  String description;
  final List<Book> _books;
  final DateTime createdAt;
  DateTime updatedAt;

  ReadingList({
    required this.id,
    required this.name,
    this.description = '',
    List<Book>? books,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _books = List.of(books ?? []),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  List<Book> get books => List.unmodifiable(_books);

  int get bookCount => _books.length;
  bool get isEmpty => _books.isEmpty;
  bool get isNotEmpty => _books.isNotEmpty;

  bool containsBook(String bookId) {
    for (var book in _books) {
      if (book.bookId == bookId) {
        return true;
      }
    }
    return false;
  }

  void addBook(Book book) {
    _books.add(book);
    updatedAt = DateTime.now();
  }

  bool removeBook(String bookId) {
    for (int i = 0; i < _books.length; i++) {
      if (_books[i].bookId == bookId) {
        _books.removeAt(i);
        updatedAt = DateTime.now();
        return true;
      }
    }
    return false;
  }
}
