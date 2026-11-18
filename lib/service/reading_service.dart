import '../model/book.dart';
import '../model/reading_history.dart';
import '../model/reading_progress.dart';
import 'book_service.dart';

class ReadingService {
  final BookService bookService;
  final Map<String, ReadingProgress> _progressByBookId = {};
  final List<ReadingHistory> _readingHistory = [];
  int _nextHistoryId = 1;
  DateTime? _lastActivityAt;

  ReadingService({required this.bookService});

  ReadingProgress? getReadingProgress(String bookId) {
    return _progressByBookId[bookId];
  }

  ReadingProgress updateProgress(String bookId, int page) {
    var book = _requireBook(bookId);
    if (!book.hasContent) {
      throw StateError('Book "$bookId" has no reading content');
    }
    if (page < 1 || page > book.totalPages) {
      throw RangeError.range(page, 1, book.totalPages, 'page');
    }

    var now = _nextActivityTime();
    var progress = _progressByBookId[bookId];

    if (progress == null) {
      progress = ReadingProgress(
        bookId: bookId,
        currentPage: page,
        totalPages: book.totalPages,
        lastReadAt: now,
      );
      _progressByBookId[bookId] = progress;
    } else {
      progress.currentPage = page;
      progress.lastReadAt = now;
    }

    return progress;
  }

  List<ReadingHistory> getReadingHistory() {
    List<ReadingHistory> history = [];
    for (var item in _readingHistory) {
      history.add(item);
    }
    history.sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));
    return List.unmodifiable(history);
  }

  ReadingHistory recordBookOpened(String bookId) {
    var book = _requireBook(bookId);
    var now = _nextActivityTime();
    var progress = _progressByBookId[bookId];

    int lastPage = 1;
    if (progress != null) {
      progress.lastReadAt = now;
      lastPage = progress.currentPage;
    }

    var history = ReadingHistory(
      id: 'reading-history-${_nextHistoryId++}',
      book: book,
      lastPageRead: lastPage,
      lastReadAt: now,
    );
    _readingHistory.add(history);
    return history;
  }

  void clearReadingHistory() {
    _readingHistory.clear();
  }

  List<Book> getContinueReadingBooks() {
    List<ReadingProgress> inProgress = [];
    for (var progress in _progressByBookId.values) {
      if (!progress.isCompleted) {
        inProgress.add(progress);
      }
    }

    inProgress.sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));

    List<Book> books = [];
    for (var progress in inProgress) {
      books.add(_requireBook(progress.bookId));
    }
    return List.unmodifiable(books);
  }

  double calculateProgress(String bookId) {
    _requireBook(bookId);
    var progress = _progressByBookId[bookId];
    if (progress == null) {
      return 0.0;
    }
    return progress.percentage;
  }

  Book _requireBook(String bookId) {
    var book = bookService.getBookById(bookId);
    if (book == null) {
      throw ArgumentError.value(bookId, 'bookId', 'Book does not exist');
    }
    return book;
  }

  DateTime _nextActivityTime() {
    var now = DateTime.now();
    if (_lastActivityAt == null || now.isAfter(_lastActivityAt!)) {
      _lastActivityAt = now;
    } else {
      _lastActivityAt = _lastActivityAt!.add(const Duration(microseconds: 1));
    }
    return _lastActivityAt!;
  }
}
