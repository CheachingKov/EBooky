import '../model/book.dart';
import '../model/book_page.dart';

final List<Book> sampleBooks = [
  Book(
    bookId: 'b1',
    title: 'Algorithms in Practice',
    author: 'Dr. Arthur Pendelton',
    bookType: 'eBook',
    genre: 'Technology',
    description: 'A practical guide exploring fundamental data structures and algorithmic thinking.',
    coverImg: 'assets/images/cover_algorithms.png',
    pages: const [
      BookPage(
        pageNum: 1,
        content: 'Chapter 1: Introduction to Data Structures\n\nData structures form the foundation of computational problem solving.',
      ),
      BookPage(
        pageNum: 2,
        content: 'Chapter 2: Computational Complexity\n\nAnalyzing algorithm efficiency requires understanding algorithmic bounds.',
      ),
    ],
  ),
  Book(
    bookId: 'b2',
    title: 'The Whispering Forest',
    author: 'Elena Vance',
    bookType: 'eBook',
    genre: 'Fiction',
    description: 'An adventurous journey through an ancient enchanted forest filled with mysteries.',
    coverImg: 'assets/images/cover_forest.png',
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
    title: 'The Habit of Success',
    author: 'Marcus Sterling',
    bookType: 'eBook',
    genre: 'Business',
    description: 'Principles and strategies for building effective daily routines and productive habits.',
    coverImg: 'assets/images/cover_habits.png',
    pages: const [],
  ),
  Book(
    bookId: 'b4',
    title: 'Beyond the Stratosphere',
    author: 'Samantha Wright',
    bookType: 'eBook',
    genre: 'Science',
    description: 'An introduction to modern astronomy and the exploration of our solar system.',
    coverImg: 'assets/images/cover_space.png',
    pages: const [],
  ),
];
