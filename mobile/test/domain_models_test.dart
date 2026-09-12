import 'package:flutter_test/flutter_test.dart';
import 'package:bramble_mobile/core/network/api_response.dart';
import 'package:bramble_mobile/features/auth/domain/auth_response.dart';
import 'package:bramble_mobile/features/auth/domain/user_preferences_model.dart';
import 'package:bramble_mobile/features/books/domain/book_detail_model.dart';
import 'package:bramble_mobile/features/books/domain/chapter_model.dart';
import 'package:bramble_mobile/features/discover/domain/discover_response_model.dart';
import 'package:bramble_mobile/features/library/domain/library_item_model.dart';
import 'package:bramble_mobile/features/reader/domain/chapter_detail_model.dart';
import 'package:bramble_mobile/features/stats/domain/stats_model.dart';

void main() {
  group('ApiResponse & PageResponse Domain Tests', () {
    test('ApiResponse parses generic list correctly', () {
      final json = {
        'success': true,
        'message': 'OK',
        'data': [
          {'id': '1', 'name': 'Fantasy', 'slug': 'fantasy'}
        ]
      };
      final res = ApiResponse<List<GenreModel>>.fromJson(
        json,
        (data) => (data as List).map((e) => GenreModel.fromJson(e)).toList(),
      );

      expect(res.success, true);
      expect(res.message, 'OK');
      expect(res.data?.first.name, 'Fantasy');
      expect(res.data?.first['slug'], 'fantasy');
    });

    test('PageResponse parses items and pagination info', () {
      final json = {
        'items': [
          {'id': 'c1', 'bookId': 'b1', 'chapterNumber': 1, 'title': 'Prologue'}
        ],
        'total': 100,
        'page': 1,
        'limit': 20,
        'totalPages': 5,
      };
      final page = PageResponse<ChapterModel>.fromJson(
        json,
        (item) => ChapterModel.fromJson(item as Map<String, dynamic>),
      );

      expect(page.total, 100);
      expect(page.totalPages, 5);
      expect(page.items.first.title, 'Prologue');
      expect(page.items.first['chapterNumber'], 1);
    });
  });

  group('Book, Author & Discover Domain Models Tests', () {
    test('BookModel and ChapterModel serialization & operator []', () {
      final bookJson = {
        'id': 'book-1',
        'title': 'The Bramble Tree',
        'slug': 'the-bramble-tree',
        'author': 'Elena Vance',
        'genres': ['Fantasy', 'Adventure'],
        'rating': 4.9,
        'readersCount': 25000,
        'totalChapters': 120,
        'isFeatured': true,
      };

      final book = BookModel.fromJson(bookJson);
      expect(book.id, 'book-1');
      expect(book.title, 'The Bramble Tree');
      expect(book['title'], 'The Bramble Tree');
      expect(book['author'], 'Elena Vance');
      expect(book['readersCount'], 25000);
      expect(book['isFeatured'], true);

      final outJson = book.toJson();
      expect(outJson['id'], 'book-1');
      expect(outJson['title'], 'The Bramble Tree');
    });

    test('AuthorModel works and operator []', () {
      final authorJson = {
        'id': 'a1',
        'name': 'Elena Vance',
        'bio': 'Award winning author',
        'followersCount': 1500,
        'isFollowed': true,
        'works': [
          {'id': 'b1', 'title': 'Book 1', 'author': 'Elena Vance'}
        ]
      };

      final author = AuthorModel.fromJson(authorJson);
      expect(author.name, 'Elena Vance');
      expect(author['followersCount'], 1500);
      expect(author['isFollowed'], true);
      expect(author.works.length, 1);
      expect(author['works'].first['title'], 'Book 1');
    });

    test('DiscoverResponseModel parsing and operator []', () {
      final discoverJson = {
        'featured': [
          {'id': 'b1', 'title': 'Featured Novel', 'author': 'Author A'}
        ],
        'popularGenres': [
          {'id': 'g1', 'name': 'Fantasy', 'slug': 'fantasy'}
        ]
      };

      final discover = DiscoverResponseModel.fromJson(discoverJson);
      expect(discover.featured.length, 1);
      expect(discover.popularGenres.first.name, 'Fantasy');
      expect(discover['featured'].first['title'], 'Featured Novel');
      expect(discover['popularGenres'].first['name'], 'Fantasy');
    });
  });

  group('Reader Domain Models Tests', () {
    test('ChapterDetailModel and UnlockResponseModel', () {
      final chJson = {
        'id': 'ch-1',
        'bookId': 'b1',
        'bookTitle': 'Epic Novel',
        'chapterNumber': 1,
        'title': 'The Awakening',
        'content': 'Once upon a time in a tranquil forest...',
        'wordCount': 1200,
        'isFree': false,
        'coinCost': 30,
        'isUnlocked': false,
      };

      final ch = ChapterDetailModel.fromJson(chJson);
      expect(ch.isLocked, true);
      expect(ch['coinCost'], 30);
      expect(ch['title'], 'The Awakening');

      final unlockJson = {
        'success': true,
        'chapterId': 'ch-1',
        'coinsDeducted': 30,
        'remainingCoins': 90,
        'message': 'Unlocked successfully',
      };
      final unlock = UnlockResponseModel.fromJson(unlockJson);
      expect(unlock.success, true);
      expect(unlock['remainingCoins'], 90);
    });

    test('ActiveReadingModel and ProgressResponseModel', () {
      final activeJson = {
        'id': 'ar-1',
        'bookId': 'b1',
        'chapterId': 'ch-1',
        'chapterNumber': 1,
        'chapterTitle': 'The Beginning',
        'progressPercent': 65,
        'scrollOffset': 350.5,
        'readingTimeSeconds': 420,
      };

      final active = ActiveReadingModel.fromJson(activeJson);
      expect(active['progressPercent'], 65);
      expect(active['chapterTitle'], 'The Beginning');
      expect(active.scrollOffset, 350.5);
    });
  });

  group('Library & Stats Domain Models Tests', () {
    test('LibraryItemModel backward compatibility operator []', () {
      final itemJson = {
        'id': 'lib-1',
        'bookId': 'b1',
        'status': 'READING',
        'progressPercent': 45,
        'lastReadChapterId': 'ch-5',
        'lastReadChapterNumber': 5,
        'book': {
          'id': 'b1',
          'title': 'Novel 1',
          'author': 'Author 1',
          'coverImageUrl': 'https://example.com/cover.jpg',
        }
      };

      final item = LibraryItemModel.fromJson(itemJson);
      expect(item.id, 'lib-1');
      expect(item['title'], 'Novel 1');
      expect(item['author'], 'Author 1');
      expect(item['progressPercent'], 45);
      expect(item['lastReadChapterNumber'], 5);
      expect(item['lastReadChapterId'], 'ch-5');
    });

    test('StatsResponseModel operator [] and chart parsing', () {
      final statsJson = {
        'totalMinutesRead': 450,
        'currentStreakDays': 7,
        'longestStreakDays': 14,
        'booksCompleted': 3,
        'chaptersRead': 85,
        'todayMinutes': 30,
        'goalMinutes': 40,
        'statCards': [
          {'label': 'Total Read', 'value': '7.5h', 'unit': 'hours', 'trend': '+12%'}
        ],
        'weeklyActivity': [
          {'day': 'Mon', 'minutes': 45, 'chapters': 3}
        ]
      };

      final stats = StatsResponseModel.fromJson(statsJson);
      expect(stats.totalMinutesRead, 450);
      expect(stats['todayMinutes'], 30);
      expect(stats['cards'].length, 1);
      expect(stats['week'].length, 1);
      expect(stats['cards'].first['label'], 'Total Read');
      expect(stats['week'].first['day'], 'Mon');
    });
  });

  group('Auth & User Preferences Models Tests', () {
    test('UserPreferencesModel serialization', () {
      const prefs = UserPreferencesModel(
        fontSize: 18,
        theme: 'dark',
        fontFamily: 'serif',
        lineHeight: 1.8,
        marginHorizontal: 24.0,
        autoUnlock: true,
        soundEffects: true,
      );

      final json = prefs.toJson();
      final fromJson = UserPreferencesModel.fromJson(json);

      expect(fromJson.fontSize, 18);
      expect(fromJson.theme, 'dark');
      expect(fromJson['themeMode'], 'dark');
      expect(fromJson['lineHeight'], 1.8);
      expect(fromJson['autoUnlock'], true);
    });

    test('AuthResponseModel parsing', () {
      final authJson = {
        'accessToken': 'jwt.token.here',
        'refreshToken': 'refresh.token.here',
        'tokenType': 'Bearer',
        'expiresIn': 86400,
        'user': {
          'id': 'u1',
          'email': 'user@bramble.com',
          'name': 'Bramble Reader',
          'role': 'USER',
          'coins': 150,
        }
      };

      final authRes = AuthResponseModel.fromJson(authJson);
      expect(authRes.accessToken, 'jwt.token.here');
      expect(authRes.user.name, 'Bramble Reader');
      expect(authRes.user['coins'], 150);
    });
  });
}
