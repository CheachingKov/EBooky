import 'package:flutter_test/flutter_test.dart';

import 'package:ebooky/data/book_data.dart';
import 'package:ebooky/model/reading_list.dart';
import 'package:ebooky/service/book_service.dart';
import 'package:ebooky/service/reading_list_service.dart';

void main() {
  late BookService bookService;
  late ReadingListService readingListService;

  setUp(() {
    bookService = BookService(books: sampleBooks);
    readingListService = ReadingListService(bookService: bookService);
  });

  group('ReadingListService', () {

    //Create Reading List
    group('createReadingList (F12)', () {
      test('creates a reading list with a valid name and description', () {
        final list = readingListService.createReadingList(
          'Personal Favorites',
          'Novels I love to re-read.',
        );

        expect(list.id, equals('rl-1'));
        expect(list.name, equals('Personal Favorites'));
        expect(list.description, equals('Novels I love to re-read.'));
        expect(list.books, isEmpty);
        expect(list.bookCount, equals(0));
        expect(list.isEmpty, isTrue);
      });

      test('trims whitespace from name and description', () {
        final list = readingListService.createReadingList(
          '   Sci-Fi Classics   ',
          '   Space opera novels   ',
        );

        expect(list.name, equals('Sci-Fi Classics'));
        expect(list.description, equals('Space opera novels'));
      });

      test('assigns sequential unique IDs to multiple lists', () {
        final list1 = readingListService.createReadingList('List 1');
        final list2 = readingListService.createReadingList('List 2');

        expect(list1.id, equals('rl-1'));
        expect(list2.id, equals('rl-2'));
      });

      test('throws ArgumentError if name is empty or whitespace', () {
        expect(
          () => readingListService.createReadingList(''),
          throwsArgumentError,
        );
        expect(
          () => readingListService.createReadingList('    '),
          throwsArgumentError,
        );
      });

      test('throws ArgumentError if name exceeds 50 characters', () {
        final longName = 'A' * 51;
        expect(
          () => readingListService.createReadingList(longName),
          throwsArgumentError,
        );
      });

      test('throws ArgumentError if duplicate name exists (case-insensitive)', () {
        readingListService.createReadingList('Mystery Novels');

        expect(
          () => readingListService.createReadingList('mystery novels'),
          throwsArgumentError,
        );
        expect(
          () => readingListService.createReadingList('  MYSTERY NOVELS  '),
          throwsArgumentError,
        );
      });
    });


    //View Reading Lists
    group('view reading lists (F13)', () {
      test('returns empty list initially', () {
        expect(readingListService.getAllReadingLists(), isEmpty);
      });

      test('returns all created reading lists as unmodifiable', () {
        readingListService.createReadingList('Favorites');
        readingListService.createReadingList('To Read');

        final allLists = readingListService.getAllReadingLists();
        expect(allLists, hasLength(2));
        expect(allLists[0].name, equals('Favorites'));
        expect(allLists[1].name, equals('To Read'));

        expect(() => allLists.clear(), throwsUnsupportedError);
      });

      test('getReadingListById returns matching list or null', () {
        final created = readingListService.createReadingList('Favorites');

        expect(readingListService.getReadingListById(created.id), equals(created));
        expect(readingListService.getReadingListById('non_existent'), isNull);
        expect(readingListService.getReadingListById(''), isNull);
      });

      test('getReadingListByName returns matching list or null', () {
        final created = readingListService.createReadingList('Favorites');

        expect(readingListService.getReadingListByName('favorites'), equals(created));
        expect(readingListService.getReadingListByName('Unknown'), isNull);
      });
    });


    //Rename Reading List
    group('renameReadingList (F14)', () {
      test('renames an existing reading list and updates description', () {
        final list = readingListService.createReadingList('Old Name', 'Old Desc');

        final updated = readingListService.renameReadingList(
          list.id,
          'New Name',
          'New Desc',
        );

        expect(updated.name, equals('New Name'));
        expect(updated.description, equals('New Desc'));
      });

      test('allows renaming to the same name (no-op duplicate check)', () {
        final list = readingListService.createReadingList('Favorites');

        expect(
          () => readingListService.renameReadingList(list.id, 'favorites'),
          returnsNormally,
        );
      });

      test('throws ArgumentError if renaming clashes with another list', () {
        final list1 = readingListService.createReadingList('List One');
        final list2 = readingListService.createReadingList('List Two');

        expect(
          () => readingListService.renameReadingList(list2.id, 'List One'),
          throwsArgumentError,
        );
      });

      test('throws ArgumentError if new name is empty or whitespace', () {
        final list = readingListService.createReadingList('Valid Name');

        expect(
          () => readingListService.renameReadingList(list.id, '   '),
          throwsArgumentError,
        );
      });

      test('throws StateError if list does not exist', () {
        expect(
          () => readingListService.renameReadingList('rl-999', 'New Name'),
          throwsStateError,
        );
      });
    });


    //Delete Reading List
    group('deleteReadingList (F15)', () {
      test('deletes an existing reading list and returns true', () {
        final list = readingListService.createReadingList('To Delete');

        final result = readingListService.deleteReadingList(list.id);

        expect(result, isTrue);
        expect(readingListService.getAllReadingLists(), isEmpty);
      });

      test('returns false if deleting a non-existent list', () {
        expect(readingListService.deleteReadingList('rl-999'), isFalse);
      });

      test('deleting a list does not delete the actual books from catalog', () {
        final list = readingListService.createReadingList('Novel Club');
        readingListService.addBookToList(list.id, 'b1');

        readingListService.deleteReadingList(list.id);

        // Books in BookService catalog remain completely intact
        expect(bookService.getBookById('b1'), isNotNull);
        expect(bookService.getAllBooks(), hasLength(sampleBooks.length));
      });
    });


    //Add Book to Reading List
    group('addBookToList (F16)', () {
      test('adds an existing book to a list successfully', () {
        final list = readingListService.createReadingList('Favorites');

        final success = readingListService.addBookToList(list.id, 'b1');

        expect(success, isTrue);
        expect(list.bookCount, equals(1));
        expect(list.containsBook('b1'), isTrue);
      });

      test('prevents adding the same book twice to the same list', () {
        final list = readingListService.createReadingList('Favorites');

        final firstAdd = readingListService.addBookToList(list.id, 'b1');
        final secondAdd = readingListService.addBookToList(list.id, 'b1');

        expect(firstAdd, isTrue);
        expect(secondAdd, isFalse);
        expect(list.bookCount, equals(1));
      });

      test('allows the same book to belong to multiple different lists', () {
        final list1 = readingListService.createReadingList('List 1');
        final list2 = readingListService.createReadingList('List 2');

        readingListService.addBookToList(list1.id, 'b1');
        readingListService.addBookToList(list2.id, 'b1');

        expect(list1.containsBook('b1'), isTrue);
        expect(list2.containsBook('b1'), isTrue);
      });

      test('throws ArgumentError if book does not exist in catalog', () {
        final list = readingListService.createReadingList('Favorites');

        expect(
          () => readingListService.addBookToList(list.id, 'invalid_book_id'),
          throwsArgumentError,
        );
      });

      test('throws StateError if list does not exist', () {
        expect(
          () => readingListService.addBookToList('rl-999', 'b1'),
          throwsStateError,
        );
      });
    });


    //Remove Book from Reading List
    group('removeBookFromList (F17)', () {
      test('removes a book from a list successfully', () {
        final list = readingListService.createReadingList('Favorites');
        readingListService.addBookToList(list.id, 'b1');

        final removed = readingListService.removeBookFromList(list.id, 'b1');

        expect(removed, isTrue);
        expect(list.bookCount, equals(0));
        expect(list.containsBook('b1'), isFalse);
      });

      test('returns false if book does not belong to the list', () {
        final list = readingListService.createReadingList('Favorites');

        final removed = readingListService.removeBookFromList(list.id, 'b1');

        expect(removed, isFalse);
      });

      test('throws StateError if list does not exist', () {
        expect(
          () => readingListService.removeBookFromList('rl-999', 'b1'),
          throwsStateError,
        );
      });
    });


    //View List Contents & Sorting
    group('getListBooks (F18)', () {
      test('returns an empty list when reading list has no books', () {
        final list = readingListService.createReadingList('Empty List');

        final books = readingListService.getListBooks(list.id);

        expect(books, isEmpty);
      });

      test('defaults to alphabetical order by title (A-Z)', () {
        final list = readingListService.createReadingList('Mixed List');

        readingListService.addBookToList(list.id, 'b1');
        readingListService.addBookToList(list.id, 'b2');
        readingListService.addBookToList(list.id, 'b3');
        readingListService.addBookToList(list.id, 'b4');

        final books = readingListService.getListBooks(list.id);

        expect(books[0].title, equals('Beneath the Autumn Sky')); // b4
        expect(books[1].title, equals('Echoes of the Starlight'));  // b3
        expect(books[2].title, equals('Shadows in the Mist'));     // b1
        expect(books[3].title, equals('The Whispering Forest'));   // b2
      });

      test('sorts by newest added first (reverse insertion order)', () {
        final list = readingListService.createReadingList('Chronological List');

        readingListService.addBookToList(list.id, 'b1');
        readingListService.addBookToList(list.id, 'b2');
        readingListService.addBookToList(list.id, 'b3');

        final books = readingListService.getListBooks(
          list.id,
          ReadingListSortOrder.newest,
        );

        expect(books[0].bookId, equals('b3')); // Newest added
        expect(books[1].bookId, equals('b2'));
        expect(books[2].bookId, equals('b1')); // Oldest added
      });

      test('sorts by oldest added first (natural insertion order)', () {
        final list = readingListService.createReadingList('Chronological List');

        readingListService.addBookToList(list.id, 'b1');
        readingListService.addBookToList(list.id, 'b2');
        readingListService.addBookToList(list.id, 'b3');

        final books = readingListService.getListBooks(
          list.id,
          ReadingListSortOrder.oldest,
        );

        expect(books[0].bookId, equals('b1')); // Oldest added
        expect(books[1].bookId, equals('b2'));
        expect(books[2].bookId, equals('b3')); // Newest added
      });

      test('returns an unmodifiable list', () {
        final list = readingListService.createReadingList('List');
        readingListService.addBookToList(list.id, 'b1');

        final books = readingListService.getListBooks(list.id);

        expect(() => books.clear(), throwsUnsupportedError);
      });

      test('throws StateError if list does not exist', () {
        expect(
          () => readingListService.getListBooks('rl-999'),
          throwsStateError,
        );
      });
    });

    group('helper features', () {
      test('getReadingListsForBook finds all lists containing a book', () {
        final list1 = readingListService.createReadingList('List 1');
        final list2 = readingListService.createReadingList('List 2');
        final list3 = readingListService.createReadingList('List 3');

        readingListService.addBookToList(list1.id, 'b1');
        readingListService.addBookToList(list3.id, 'b1');

        final matching = readingListService.getReadingListsForBook('b1');

        expect(matching, hasLength(2));
        expect(matching.map((l) => l.id), containsAll(['rl-1', 'rl-3']));
      });

      test('searchReadingLists finds lists matching query (case-insensitive)', () {
        readingListService.createReadingList('Fantasy Favorites');
        readingListService.createReadingList('Sci-Fi Best');
        readingListService.createReadingList('Dark Fantasy Picks');

        final results = readingListService.searchReadingLists('fantasy');

        expect(results, hasLength(2));
        expect(results.map((l) => l.name), containsAll([
          'Fantasy Favorites',
          'Dark Fantasy Picks',
        ]));
      });

      test('searchReadingLists with empty query returns all lists', () {
        readingListService.createReadingList('List 1');
        readingListService.createReadingList('List 2');

        expect(readingListService.searchReadingLists(''), hasLength(2));
        expect(readingListService.searchReadingLists('   '), hasLength(2));
      });
    });
  });
}
