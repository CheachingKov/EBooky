import 'book.dart';
import 'reading_status.dart';

class LibraryItem {
  final Book book;
  ReadingStatus status;
  bool isFavorite;
  final DateTime addedAt;

  LibraryItem({
    required this.book,
    this.status = ReadingStatus.unread,
    this.isFavorite = false,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}