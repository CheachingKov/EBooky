import 'book.dart';

class ReadingHistory {
  final String id;
  final Book book;
  final int lastPageRead;
  final DateTime lastReadAt;

  ReadingHistory({
    required this.id,
    required this.book,
    required this.lastPageRead,
    DateTime? lastReadAt,
  }) : lastReadAt = lastReadAt ?? DateTime.now();
}