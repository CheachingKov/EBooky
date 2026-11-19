import 'package:flutter_test/flutter_test.dart';

import 'package:ebooky/data/book_data.dart';
import 'package:ebooky/model/book_genre.dart';
import 'package:ebooky/service/book_service.dart';

void main() {
  late BookService bookService;

  setUp(() {
    bookService = BookService(books: sampleBooks);
  });

  group('BookService', () {
    // Browse All Books
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

    // View Book Details (getBookById)
    group('getBookById', () {
      test('returns book details when book exists', () {
        final book = bookService.getBookById('b1');

        expect(book, isNotNull);
        expect(book!.title, 'Shadows in the Mist');
        expect(book.author, 'Arthur Pendelton');
        expect(book.genre, BookGenre.mystery);
        expect(book.publishDate, equals(DateTime(2023, 5, 14)));
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

    // View Book Details by Title (getBookByTitle)
    group('getBookByTitle', () {
      test('returns book details when title matches', () {
        final book = bookService.getBookByTitle('Shadows in the Mist');

        expect(book, isNotNull);
        expect(book!.bookId, 'b1');
        expect(book.author, 'Arthur Pendelton');
      });

      test('matching is case-insensitive and trims whitespace', () {
        final book = bookService.getBookByTitle('  shadows in the mist  ');

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

    // Search Books
    group('searchBooks', () {
      test('searches books by title (case-insensitive substring)', () {
        final results = bookService.searchBooks('shadows');
        expect(results, hasLength(1));
        expect(results.first.bookId, 'b1');
      });

      test('searches books by author (case-insensitive substring)', () {
        final results = bookService.searchBooks('vance');
        expect(results, hasLength(1));
        expect(results.first.bookId, 'b2');
      });

      test('searches books by genre name', () {
        final results = bookService.searchBooks('romance');
        expect(results, hasLength(1));
        expect(results.first.bookId, 'b4');
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

    // Filter by Genre
    group('getBooksByGenre', () {
      test('filters books matching the genre', () {
        final mysteryBooks = bookService.getBooksByGenre(BookGenre.mystery);
        expect(mysteryBooks, hasLength(1));
        expect(mysteryBooks.first.bookId, 'b1');
      });

      test('filters another genre correctly', () {
        final fantasyBooks = bookService.getBooksByGenre(BookGenre.fantasy);
        expect(fantasyBooks, hasLength(1));
        expect(fantasyBooks.first.bookId, 'b2');
      });

      test('returns empty list if genre has no books', () {
        final horrorBooks = bookService.getBooksByGenre(BookGenre.horror);
        expect(horrorBooks, isEmpty);
      });

      test('returns an unmodifiable list', () {
        expect(
          () => bookService.getBooksByGenre(BookGenre.mystery).clear(),
          throwsUnsupportedError,
        );
      });
    });

    // Browse All Genres
    group('getAllGenres', () {
      test('returns all predefined BookGenre enum values', () {
        final genres = bookService.getAllGenres();
        expect(genres, equals(BookGenre.values));
        expect(genres, contains(BookGenre.action));
        expect(genres, contains(BookGenre.fantasy));
        expect(genres, contains(BookGenre.mystery));
        expect(genres, contains(BookGenre.romance));
        expect(genres, contains(BookGenre.sciFi));
      });
    });
  });
}
