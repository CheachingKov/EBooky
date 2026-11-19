import 'package:ebooky/model/book_page.dart';
import 'book_genre.dart';

class Book {
  final String bookId;
  final String title;
  final String author;
  final BookGenre genre;
  final String description;
  final String coverImg;
  final List<BookPage> _pages;

  Book({
    required this.bookId,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.coverImg,
    List<BookPage> pages = const [],
  }) : _pages = List.unmodifiable(pages);

  List<BookPage> get pages => _pages;

  int get totalPages => _pages.length;
  bool get hasContent => _pages.isNotEmpty;
}
