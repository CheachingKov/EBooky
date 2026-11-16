class ReadingProgress {
  final String bookId;
  int currentPage;
  final int totalPages;
  DateTime lastReadAt;

  ReadingProgress({
    required this.bookId,
    required this.currentPage,
    required this.totalPages,
    DateTime? lastReadAt,
  }) : lastReadAt = lastReadAt ?? DateTime.now();

  double get percentage =>
      totalPages > 0 ? (currentPage / totalPages) * 100 : 0.0;

  bool get isCompleted => totalPages > 0 && currentPage >= totalPages;
}