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

  ReadingProgress? getReadingProgress(String bookId) =>
      _progressByBookId[bookId];

  ReadingProgress updateProgress(String bookId, int page) {
    final book = _requireBook(bookId);
    if (!book.hasContent) {
      throw StateError('Book "$bookId" has no reading content');
    }
    if (page < 1 || page > book.totalPages) {
      throw RangeError.range(page, 1, book.totalPages, 'page');
    }

    final now = _nextActivityTime();
    final progress = _progressByBookId.putIfAbsent(
      bookId,
      () => ReadingProgress(
        bookId: bookId,
        currentPage: page,
        totalPages: book.totalPages,
        lastReadAt: now,
      ),
    );
    progress
      ..currentPage = page
      ..lastReadAt = now;
    return progress;
  }

  List<ReadingHistory> getReadingHistory() {
    final history = List<ReadingHistory>.of(_readingHistory)
      ..sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));
    return List.unmodifiable(history);
  }

  ReadingHistory recordBookOpened(String bookId) {
    final book = _requireBook(bookId);
    final now = _nextActivityTime();
    final progress = _progressByBookId[bookId];
    if (progress != null) {
      progress.lastReadAt = now;
    }

    final history = ReadingHistory(
      id: 'reading-history-${_nextHistoryId++}',
      book: book,
      lastPageRead: progress?.currentPage ?? 1,
      lastReadAt: now,
    );
    _readingHistory.add(history);
    return history;
  }

  List<Book> getContinueReadingBooks() {
    final progressRecords =
        _progressByBookId.values
            .where((progress) => !progress.isCompleted)
            .toList()
          ..sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));

    return List.unmodifiable(
      progressRecords.map((progress) => _requireBook(progress.bookId)),
    );
  }

  double calculateProgress(String bookId) {
    _requireBook(bookId);
    return _progressByBookId[bookId]?.percentage ?? 0.0;
  }

  Book _requireBook(String bookId) {
    final book = bookService.getBookById(bookId);
    if (book == null) {
      throw ArgumentError.value(bookId, 'bookId', 'Book does not exist');
    }
    return book;
  }

  DateTime _nextActivityTime() {
    final now = DateTime.now();
    if (_lastActivityAt == null || now.isAfter(_lastActivityAt!)) {
      _lastActivityAt = now;
    } else {
      _lastActivityAt = _lastActivityAt!.add(const Duration(microseconds: 1));
    }
    return _lastActivityAt!;
  }
}
