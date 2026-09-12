class StatCardModel {
  final String label;
  final String value;
  final String unit;
  final String trend;

  const StatCardModel({
    required this.label,
    required this.value,
    this.unit = '',
    this.trend = '',
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'label':
        return label;
      case 'value':
        return value;
      case 'unit':
        return unit;
      case 'trend':
        return trend;
      default:
        return null;
    }
  }

  factory StatCardModel.fromJson(Map<String, dynamic> json) {
    return StatCardModel(
      label: (json['label'] ?? '').toString(),
      value: (json['value'] ?? '').toString(),
      unit: (json['unit'] ?? '').toString(),
      trend: (json['trend'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'unit': unit,
      'trend': trend,
    };
  }
}

class DayChartModel {
  final String day;
  final int minutes;
  final int chapters;

  const DayChartModel({
    required this.day,
    this.minutes = 0,
    this.chapters = 0,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'day':
        return day;
      case 'minutes':
        return minutes;
      case 'chapters':
        return chapters;
      default:
        return null;
    }
  }

  factory DayChartModel.fromJson(Map<String, dynamic> json) {
    return DayChartModel(
      day: (json['day'] ?? '').toString(),
      minutes: (json['minutes'] as num?)?.toInt() ?? 0,
      chapters: (json['chapters'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'minutes': minutes,
      'chapters': chapters,
    };
  }
}

class StatsResponseModel {
  final int totalMinutesRead;
  final int currentStreakDays;
  final int longestStreakDays;
  final int booksCompleted;
  final int chaptersRead;
  final int todayMinutes;
  final int goalMinutes;
  final String peakInsight;
  final List<StatCardModel> cards;
  final List<DayChartModel> weeklyActivity;

  const StatsResponseModel({
    this.totalMinutesRead = 0,
    this.currentStreakDays = 0,
    this.longestStreakDays = 0,
    this.booksCompleted = 0,
    this.chaptersRead = 0,
    this.todayMinutes = 27,
    this.goalMinutes = 40,
    this.peakInsight = 'You read most between 21:00 and 23:00. Bramble delivers fresh chapters tailored to your reading time.',
    this.cards = const [],
    this.weeklyActivity = const [],
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'totalMinutesRead':
        return totalMinutesRead;
      case 'currentStreakDays':
        return currentStreakDays;
      case 'longestStreakDays':
        return longestStreakDays;
      case 'booksCompleted':
        return booksCompleted;
      case 'chaptersRead':
        return chaptersRead;
      case 'todayMinutes':
        return todayMinutes;
      case 'goalMinutes':
        return goalMinutes;
      case 'peakInsight':
        return peakInsight;
      case 'cards':
      case 'statCards':
        return cards;
      case 'weeklyActivity':
      case 'week':
        return weeklyActivity;
      default:
        return null;
    }
  }

  factory StatsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawCards = json['cards'] as List? ?? json['statCards'] as List? ?? [];
    final rawWeekly = json['weeklyActivity'] as List? ?? json['week'] as List? ?? [];

    return StatsResponseModel(
      totalMinutesRead: (json['totalMinutesRead'] as num?)?.toInt() ?? 0,
      currentStreakDays: (json['currentStreakDays'] as num?)?.toInt() ?? 0,
      longestStreakDays: (json['longestStreakDays'] as num?)?.toInt() ?? 0,
      booksCompleted: (json['booksCompleted'] as num?)?.toInt() ?? 0,
      chaptersRead: (json['chaptersRead'] as num?)?.toInt() ?? 0,
      todayMinutes: (json['todayMinutes'] as num?)?.toInt() ?? 27,
      goalMinutes: (json['goalMinutes'] as num?)?.toInt() ?? 40,
      peakInsight: json['peakInsight']?.toString() ??
          'You read most between 21:00 and 23:00. Bramble delivers fresh chapters tailored to your reading time.',
      cards: rawCards
          .whereType<Map<String, dynamic>>()
          .map((c) => StatCardModel.fromJson(c))
          .toList(),
      weeklyActivity: rawWeekly
          .whereType<Map<String, dynamic>>()
          .map((w) => DayChartModel.fromJson(w))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMinutesRead': totalMinutesRead,
      'currentStreakDays': currentStreakDays,
      'longestStreakDays': longestStreakDays,
      'booksCompleted': booksCompleted,
      'chaptersRead': chaptersRead,
      'todayMinutes': todayMinutes,
      'goalMinutes': goalMinutes,
      'peakInsight': peakInsight,
      'cards': cards.map((c) => c.toJson()).toList(),
      'statCards': cards.map((c) => c.toJson()).toList(),
      'weeklyActivity': weeklyActivity.map((w) => w.toJson()).toList(),
      'week': weeklyActivity.map((w) => w.toJson()).toList(),
    };
  }
}
