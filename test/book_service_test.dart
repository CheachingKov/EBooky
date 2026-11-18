import 'package:flutter_test/flutter_test.dart';

import 'package:ebooky/data/book_data.dart';
import 'package:ebooky/model/book_category.dart';
import 'package:ebooky/service/book_service.dart';

void main() {
  late BookService bookService;

  setUp(() {
    bookService = BookService(books: sampleBooks);
  });

  group('BookService', () {
    // ---------------------------------
    // Browse All Books
    // ---------------------------------
    group('getAllBooks', () {
      test('returns all books from the catalog', () {
        final books = bookService.getAllBooks();
        expect(books, hasLength(sampleBooks.length));
      });

      test('returns an unmodifiable list', () {
        expect(
          () => bookService.getAllBooks().clear(),
          throwsUnsupportedError,
        );
      });
    });

    // ---------------------------------
    // View Book Details (getBookById)
    // ---------------------------------
    group('getBookById', () {
      test('returns book details when book exists', () {
        final book = bookService.getBookById('b1');

        expect(book, isNotNull);
        expect(book!.title, 'Algorithms in Practice');
        expect(book.author, 'Dr. Arthur Pendelton');
        expect(book.genre, 'Technology');
        expect(book.bookType, BookCategory.educational);
        expect(book.description, isNotEmpty);
      });

      test('returns null when book does not exist (book not found)', () {
        final book = bookService.getBookById('non_existent_id');
        expect(book, isNull);
      });

      test('returns null for empty or whitespace bookId', () {
        expect(bookService.getBookById(''), isNull);
        expect(bookService.getBookById('   '), isNull);
      });
    });

    // ---------------------------------
    // View Book Details by Title (getBookByTitle)
    // ---------------------------------
    group('getBookByTitle', () {
      test('returns book details when title matches', () {
        final book = bookService.getBookByTitle('Algorithms in Practice');

        expect(book, isNotNull);
        expect(book!.bookId, 'b1');
        expect(book.author, 'Dr. Arthur Pendelton');
      });

      test('matching is case-insensitive and trims whitespace', () {
        final book = bookService.getBookByTitle('  algorithms in practice  ');

        expect(book, isNotNull);
        expect(book!.bookId, 'b1');
      });

      test('returns null when book title does not exist (book not found)', () {
        final book = bookService.getBookByTitle('Non Existent Title');
        expect(book, isNull);
      });

      test('returns null for empty or whitespace title', () {
        expect(bookService.getBookByTitle(''), isNull);
        expect(bookService.getBookByTitle('   '), isNull);
      });
    });

    // ---------------------------------
    // Search Books
    // ---------------------------------
    group('searchBooks', () {
      test('searches books by title (case-insensitive substring)', () {
        final results = bookService.searchBooks('algo');
        expect(results, hasLength(1));
        expect(results.first.bookId, 'b1');
      });

      test('searches books by author (case-insensitive substring)', () {
        final results = bookService.searchBooks('vance');
        expect(results, hasLength(1));
        expect(results.first.bookId, 'b2');
      });

      test('returns empty list when no book matches query (book not found)', () {
        final results = bookService.searchBooks('unknown query 12345');
        expect(results, isEmpty);
      });

      test('returns all books when query is empty or whitespace', () {
        expect(bookService.searchBooks(''), hasLength(sampleBooks.length));
        expect(bookService.searchBooks('   '), hasLength(sampleBooks.length));
      });
    });

    // ---------------------------------
    // Filter by Genre
    // ---------------------------------
    group('getBooksByGenre', () {
      test('filters books matching the genre', () {
        final techBooks = bookService.getBooksByGenre('Technology');
        expect(techBooks, hasLength(1));
        expect(techBooks.first.bookId, 'b1');
      });

      test('matching is case-insensitive', () {
        final fictionBooks = bookService.getBooksByGenre('fiction');
        expect(fictionBooks, hasLength(1));
        expect(fictionBooks.first.bookId, 'b2');
      });

      test('returns empty list if genre does not exist', () {
        final results = bookService.getBooksByGenre('NonExistentGenre');
        expect(results, isEmpty);
      });

      test('returns all books if genre is empty or "all"', () {
        expect(bookService.getBooksByGenre(''), hasLength(sampleBooks.length));
        expect(bookService.getBooksByGenre('all'), hasLength(sampleBooks.length));
      });
    });

    // ---------------------------------
    // Filter by Book Type
    // ---------------------------------
    group('getBooksByType', () {
      test('filters books matching the book category', () {
        final novels = bookService.getBooksByType(BookCategory.novel);
        expect(novels, hasLength(1));
        expect(novels.first.bookId, 'b2');
      });

      test('returns empty list if no books match category', () {
        final manga = bookService.getBooksByType(BookCategory.manga);
        expect(manga, isEmpty);
      });
    });

    // ---------------------------------
    // Browse Genres & Types
    // ---------------------------------
    group('browse genres and types', () {
      test('getAllGenres returns unique sorted list of genres', () {
        final genres = bookService.getAllGenres();
        expect(genres, contains('Technology'));
        expect(genres, contains('Fiction'));
        expect(genres, contains('Business'));
        expect(genres, contains('Science'));

        // Check sorted order
        final sorted = List<String>.of(genres)..sort();
        expect(genres, equals(sorted));
      });

      test('getAllBookTypes returns all category enum values', () {
        final types = bookService.getAllBookTypes();
        expect(types, contains(BookCategory.novel));
        expect(types, contains(BookCategory.manga));
      });
    });
  });
}
