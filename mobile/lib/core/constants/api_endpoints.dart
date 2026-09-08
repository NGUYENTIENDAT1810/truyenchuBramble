class ApiEndpoints {
  // Default to localhost:8080 (or 10.0.2.2 for Android emulator)
  static String baseUrl = 'http://192.168.50.116:8080/api';
  static String webBaseUrl = 'http://localhost:8080/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/me';
  static const String updatePreferences = '/auth/preferences';

  // Books
  static const String books = '/books';
  static const String discover = '/books/discover';
  static const String author = '/books/authors';

  // Chapters
  static const String chaptersByBook = '/chapters/book';
  static const String chapterContent = '/chapters';
  static const String unlockChapter = '/chapters';

  // Library
  static const String library = '/library';
  static const String toggleSave = '/library/toggle-save';
  static const String updateLibraryStatus = '/library/status';

  // Reader
  static const String activeReading = '/reader/active';
  static const String syncProgress = '/reader/progress';

  // Comments
  static const String chapterComments = '/comments/chapter';
  static const String createComment = '/comments';
  static const String likeComment = '/comments';

  // Stats
  static const String stats = '/stats/me';
}
