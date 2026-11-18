import 'package:flutter_test/flutter_test.dart';

import 'package:ebooky/data/book_data.dart';
import 'package:ebooky/service/book_service.dart';
import 'package:ebooky/service/reading_service.dart';

void main() {
  late ReadingService readingService;

  setUp(() {
    readingService = ReadingService(
      bookService: BookService(books: sampleBooks),
    );
  });

  group('reading progress', () {
    test('returns null before progress is recorded', () {
      expect(readingService.getReadingProgress('b1'), isNull);
    });

    test('updates existing progress without creating duplicates', () {
      final first = readingService.updateProgress('b1', 1);
      final second = readingService.updateProgress('b1', 2);

      expect(identical(first, second), isTrue);
      expect(readingService.getReadingProgress('b1'), same(first));
      expect(first.currentPage, 2);
      expect(first.totalPages, 2);
    });

    test('rejects progress for books without content', () {
      expect(() => readingService.updateProgress('b3', 1), throwsStateError);
    });

    test('rejects pages outside the book range', () {
      expect(() => readingService.updateProgress('b1', 0), throwsRangeError);
      expect(() => readingService.updateProgress('b1', 3), throwsRangeError);
    });

    test('rejects unknown books', () {
      expect(
        () => readingService.updateProgress('missing', 1),
        throwsArgumentError,
      );
    });

    test('calculates completion percentage', () {
      readingService.updateProgress('b1', 1);
      expect(readingService.calculateProgress('b1'), 50);
      expect(readingService.calculateProgress('b2'), 0);
    });
  });

  group('reading history', () {
    test('records each book opening and returns recent records first', () {
      final first = readingService.recordBookOpened('b1');
      final second = readingService.recordBookOpened('b1');

      expect(readingService.getReadingHistory(), hasLength(2));
      expect(readingService.getReadingHistory().first.id, second.id);
      expect(second.id, isNot(first.id));
    });

    test('records the current page when a book has progress', () {
      readingService.updateProgress('b1', 2);

      final history = readingService.recordBookOpened('b1');

      expect(history.lastPageRead, 2);
    });

    test('returns history as an unmodifiable list', () {
      readingService.recordBookOpened('b1');

      expect(
        () => readingService.getReadingHistory().clear(),
        throwsUnsupportedError,
      );
    });

    test('clears reading history without deleting reading progress', () {
      readingService.updateProgress('b1', 2);
      readingService.recordBookOpened('b1');
      readingService.recordBookOpened('b2');

      expect(readingService.getReadingHistory(), hasLength(2));

      readingService.clearReadingHistory();

      expect(readingService.getReadingHistory(), isEmpty);
      expect(readingService.getReadingProgress('b1')?.currentPage, 2);
    });
  });

  group('continue reading', () {
    test('returns incomplete books and excludes completed books', () {
      readingService.updateProgress('b1', 1);
      readingService.updateProgress('b2', 2);

      expect(
        readingService.getContinueReadingBooks().map((book) => book.bookId),
        ['b1'],
      );
    });

    test('returns books in most recently updated order', () async {
      readingService.updateProgress('b1', 1);
      await Future<void>.delayed(const Duration(milliseconds: 1));
      readingService.updateProgress('b2', 1);

      expect(
        readingService.getContinueReadingBooks().map((book) => book.bookId),
        ['b2', 'b1'],
      );
    });
  });
}
