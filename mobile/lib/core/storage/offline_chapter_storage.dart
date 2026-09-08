import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class OfflineChapterStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveChapter(String chapterId, Map<String, dynamic> chapterData) async {
    await init();
    final all = getSavedChapters();
    all[chapterId] = chapterData;
    await _prefs?.setString(AppConstants.offlineChaptersKey, jsonEncode(all));
  }

  static Map<String, dynamic>? getChapter(String chapterId) {
    final all = getSavedChapters();
    return all[chapterId];
  }

  static bool isChapterDownloaded(String chapterId) {
    final all = getSavedChapters();
    return all.containsKey(chapterId);
  }

  static Map<String, dynamic> getSavedChapters() {
    final str = _prefs?.getString(AppConstants.offlineChaptersKey);
    if (str == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(str));
    } catch (_) {
      return {};
    }
  }

  static Future<void> removeChapter(String chapterId) async {
    await init();
    final all = getSavedChapters();
    all.remove(chapterId);
    await _prefs?.setString(AppConstants.offlineChaptersKey, jsonEncode(all));
  }
}
