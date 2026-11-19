import '../model/book.dart';
import '../model/book_genre.dart';
import '../model/book_page.dart';

final List<Book> sampleBooks = [
  Book(
    bookId: 'b1',
    title: 'Shadows in the Mist',
    author: 'Arthur Pendelton',
    genre: BookGenre.mystery,
    description: 'A detective unravels a web of secrets in a fog-drenched Victorian town.',
    coverImg: 'assets/images/cover_shadows.png',
    publishDate: DateTime(2023, 5, 14),
    pages: const [
      BookPage(
        pageNum: 1,
        content: 'Chapter 1: The Midnight Bell\n\nThe thick fog rolled through the cobblestone streets as the clock tower struck twelve.',
      ),
      BookPage(
        pageNum: 2,
        content: 'Chapter 2: A Clue in the Dark\n\nDetective Arthur knelt by the lantern light, examining the peculiar golden crest.',
      ),
    ],
  ),
  Book(
    bookId: 'b2',
    title: 'The Whispering Forest',
    author: 'Elena Vance',
    genre: BookGenre.fantasy,
    description: 'An adventurous journey through an ancient enchanted forest filled with mysteries.',
    coverImg: 'assets/images/cover_forest.png',
    publishDate: DateTime(2022, 11, 20),
    pages: const [
      BookPage(
        pageNum: 1,
        content: 'Part I: The Forgotten Path\n\nThe twilight cast long shadows across the emerald canopy as the journey began.',
      ),
      BookPage(
        pageNum: 2,
        content: 'Part II: The Ancient Gateway\n\nBefore them stood the weathered archway of stones that guarded the valley.',
      ),
    ],
  ),
  Book(
    bookId: 'b3',
    title: 'Echoes of the Starlight',
    author: 'Marcus Sterling',
    genre: BookGenre.sciFi,
    description: 'A thrilling space opera across uncharted solar systems on the brink of discovery.',
    coverImg: 'assets/images/cover_starlight.png',
    publishDate: DateTime(2024, 1, 10),
    pages: const [],
  ),
  Book(
    bookId: 'b4',
    title: 'Beneath the Autumn Sky',
    author: 'Samantha Wright',
    genre: BookGenre.romance,
    description: 'A heartwarming story of two childhood friends reuniting in a quiet coastal town.',
    coverImg: 'assets/images/cover_autumn.png',
    publishDate: DateTime(2023, 9, 5),
    pages: const [],
  ),
];
