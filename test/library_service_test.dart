import 'package:flutter_test/flutter_test.dart';

import 'package:ebooky/data/book_data.dart';
import 'package:ebooky/model/reading_status.dart';
import 'package:ebooky/service/book_service.dart';
import 'package:ebooky/service/library_service.dart';

void main() {
  late LibraryService libraryService;

  const bookId = 'b1';

  setUp(() {
    libraryService = LibraryService(
      bookService: BookService(books: sampleBooks),
    );
  });

  group('LibraryService', () {
    // ---------------------------------
    // Get Library Items
    // ---------------------------------

    group('getLibraryItems', () {
      test('returns an empty list initially', () {
        expect(libraryService.getLibraryItems(), isEmpty);
      });

      test('returns an unmodifiable list', () {
        expect(
          () => libraryService.getLibraryItems().clear(),
          throwsUnsupportedError,
        );
      });
    });

    // ---------------------------------
    // Add to Library
    // ---------------------------------

    group('addToLibrary', () {
      test('adds an existing book successfully', () {
        final item = libraryService.addToLibrary(bookId);

        expect(libraryService.getLibraryItems(), hasLength(1));
        expect(item.book.bookId, bookId);
      });

      test('does not add the same book twice', () {
        final first = libraryService.addToLibrary(bookId);
        final second = libraryService.addToLibrary(bookId);

        expect(libraryService.getLibraryItems(), hasLength(1));
        expect(identical(first, second), isTrue);
      });

      test('throws ArgumentError for nonexistent book', () {
        expect(
          () => libraryService.addToLibrary('INVALID'),
          throwsArgumentError,
        );

        expect(libraryService.getLibraryItems(), isEmpty);
      });
    });

    // ---------------------------------
    // Remove from Library
    // ---------------------------------

    group('removeFromLibrary', () {
      test('removes an existing book', () {
        libraryService.addToLibrary(bookId);

        final result = libraryService.removeFromLibrary(bookId);

        expect(result, isTrue);
        expect(libraryService.getLibraryItems(), isEmpty);
      });

      test('returns false for nonexistent book', () {
        final result = libraryService.removeFromLibrary('INVALID');

        expect(result, isFalse);
      });
    });

    // ---------------------------------
    // Update Reading Status
    // ---------------------------------

    group('updateReadingStatus', () {
      test('updates the book status', () {
        final item = libraryService.addToLibrary(bookId);

        libraryService.updateReadingStatus(bookId, ReadingStatus.completed);

        expect(item.status, ReadingStatus.completed);
      });

      test('throws StateError if book is not in library', () {
        expect(
          () => libraryService.updateReadingStatus(
            bookId,
            ReadingStatus.completed,
          ),
          throwsStateError,
        );
      });
    });

    // ---------------------------------
    // Toggle Favorite
    // ---------------------------------

    group('toggleFavorite', () {
      test('changes favorite from false to true', () {
        final item = libraryService.addToLibrary(bookId);

        final result = libraryService.toggleFavorite(bookId);

        expect(result, isTrue);
        expect(item.isFavorite, isTrue);
      });

      test('changes favorite from true to false', () {
        final item = libraryService.addToLibrary(bookId);

        libraryService.toggleFavorite(bookId);
        final result = libraryService.toggleFavorite(bookId);

        expect(result, isFalse);
        expect(item.isFavorite, isFalse);
      });

      test('throws StateError if book is not in library', () {
        expect(() => libraryService.toggleFavorite(bookId), throwsStateError);
      });
    });

    // ---------------------------------
    // Create Reading List
    // ---------------------------------

    group('createReadingList', () {
      test('creates a reading list successfully', () {
        final list = libraryService.createReadingList('Personal Development');

        expect(list.name, 'Personal Development');
        expect(list.id, 'reading-list-1');
        expect(libraryService.getReadingLists(), hasLength(1));
      });

      test('trims whitespace from list name', () {
        final list = libraryService.createReadingList('  Programming  ');

        expect(list.name, 'Programming');
      });

      test('throws ArgumentError for empty name', () {
        expect(() => libraryService.createReadingList(''), throwsArgumentError);
      });

      test('throws ArgumentError for whitespace-only name', () {
        expect(
          () => libraryService.createReadingList('   '),
          throwsArgumentError,
        );
      });

      test('rejects duplicate names regardless of case', () {
        libraryService.createReadingList('Programming');

        expect(
          () => libraryService.createReadingList('programming'),
          throwsArgumentError,
        );
      });

      test('generates unique IDs', () {
        final first = libraryService.createReadingList('Programming');
        final second = libraryService.createReadingList('Personal');

        expect(first.id, isNot(second.id));
      });
    });

    // ---------------------------------
    // Get Reading Lists
    // ---------------------------------

    group('getReadingLists', () {
      test('returns an empty list initially', () {
        expect(libraryService.getReadingLists(), isEmpty);
      });

      test('returns an unmodifiable list', () {
        expect(
          () => libraryService.getReadingLists().clear(),
          throwsUnsupportedError,
        );
      });
    });

    // ---------------------------------
    // Add Book to Reading List
    // ---------------------------------

    group('addBookToList', () {
      test('adds an existing book to a reading list', () {
        final list = libraryService.createReadingList('Programming');

        libraryService.addBookToList(list.id, bookId);

        expect(list.books, hasLength(1));
        expect(list.books.first.bookId, bookId);
      });

      test('does not add duplicate books', () {
        final list = libraryService.createReadingList('Programming');

        libraryService.addBookToList(list.id, bookId);
        libraryService.addBookToList(list.id, bookId);

        expect(list.books, hasLength(1));
      });

      test('throws ArgumentError for nonexistent book', () {
        final list = libraryService.createReadingList('Programming');

        expect(
          () => libraryService.addBookToList(list.id, 'INVALID'),
          throwsArgumentError,
        );

        expect(list.books, isEmpty);
      });

      test('throws StateError for nonexistent reading list', () {
        expect(
          () => libraryService.addBookToList('INVALID', bookId),
          throwsStateError,
        );
      });
    });

    // ---------------------------------
    // Remove Book from Reading List
    // ---------------------------------

    group('removeBookFromList', () {
      test('removes an existing book from a list', () {
        final list = libraryService.createReadingList('Programming');

        libraryService.addBookToList(list.id, bookId);

        final result = libraryService.removeBookFromList(list.id, bookId);

        expect(result, isTrue);
        expect(list.books, isEmpty);
      });

      test('returns false if book is not in the list', () {
        final list = libraryService.createReadingList('Programming');

        final result = libraryService.removeBookFromList(list.id, bookId);

        expect(result, isFalse);
      });

      test('throws StateError for nonexistent reading list', () {
        expect(
          () => libraryService.removeBookFromList('INVALID', bookId),
          throwsStateError,
        );
      });
    });

    // ---------------------------------
    // Reading List Independence
    // ---------------------------------

    group('reading list independence', () {
      test('removing a book from library does not remove it from lists', () {
        final list = libraryService.createReadingList('Programming');

        libraryService.addToLibrary(bookId);
        libraryService.addBookToList(list.id, bookId);

        libraryService.removeFromLibrary(bookId);

        expect(libraryService.getLibraryItems(), isEmpty);
        expect(list.books, hasLength(1));
      });
    });
  });
}
