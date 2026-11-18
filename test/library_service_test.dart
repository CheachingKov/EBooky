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

    // Get Library Items
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


    // Contains Book
    group('containsBook', () {
      test('returns false when book is not in library', () {
        expect(libraryService.containsBook(bookId), isFalse);
      });

      test('returns true when book is added to library', () {
        libraryService.addBook(bookId);
        expect(libraryService.containsBook(bookId), isTrue);
      });
    });

    // Add to Library
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

    // Remove from Library
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

    // Update Reading Status
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

    // Toggle Favorite
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

    // Get Favorite Books (F10)
    group('getFavoriteBooks', () {
      test('returns empty list when no books are favorited', () {
        libraryService.addBook(bookId);
        expect(libraryService.getFavoriteBooks(), isEmpty);
      });

      test('returns only favorited books', () {
        libraryService.addBook('b1');
        libraryService.addBook('b2');

        libraryService.toggleFavorite('b1');

        final favorites = libraryService.getFavoriteBooks();
        expect(favorites, hasLength(1));
        expect(favorites.first.bookId, 'b1');
      });

      test('returns unmodifiable list', () {
        expect(
          () => libraryService.getFavoriteBooks().clear(),
          throwsUnsupportedError,
        );
      });
    });


    // Filter My Library (F11)
    group('filterByStatus', () {
      test('returns only books with matching status', () {
        libraryService.addBook('b1'); // default unread
        libraryService.addBook('b2');

        libraryService.updateReadingStatus('b2', ReadingStatus.completed);

        final unreadItems = libraryService.filterByStatus(ReadingStatus.unread);
        final completedItems =
            libraryService.filterByStatus(ReadingStatus.completed);
        final wishlistItems =
            libraryService.filterByStatus(ReadingStatus.wishlist);

        expect(unreadItems, hasLength(1));
        expect(unreadItems.first.book.bookId, 'b1');

        expect(completedItems, hasLength(1));
        expect(completedItems.first.book.bookId, 'b2');

        expect(wishlistItems, isEmpty);
      });

      test('returns unmodifiable list', () {
        expect(
          () => libraryService.filterByStatus(ReadingStatus.unread).clear(),
          throwsUnsupportedError,
        );
      });
    });
  });
}
