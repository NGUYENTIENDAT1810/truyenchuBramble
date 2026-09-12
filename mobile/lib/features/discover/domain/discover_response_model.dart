import '../../books/domain/book_detail_model.dart';

class DiscoverResponseModel {
  final List<BookModel> featured;
  final List<BookModel> trending;
  final List<BookModel> newReleases;
  final List<GenreModel> popularGenres;
  final List<AuthorModel> popularAuthors;

  const DiscoverResponseModel({
    this.featured = const [],
    this.trending = const [],
    this.newReleases = const [],
    this.popularGenres = const [],
    this.popularAuthors = const [],
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'featured':
        return featured;
      case 'trending':
        return trending;
      case 'newReleases':
        return newReleases;
      case 'popularGenres':
      case 'tags':
        return popularGenres;
      case 'popularAuthors':
        return popularAuthors;
      default:
        return null;
    }
  }

  factory DiscoverResponseModel.fromJson(Map<String, dynamic> json) {
    final rawFeatured = json['featured'] as List? ?? [];
    final rawTrending = json['trending'] as List? ?? [];
    final rawNewReleases = json['newReleases'] as List? ?? [];
    final rawGenres = json['popularGenres'] as List? ?? json['tags'] as List? ?? [];
    final rawAuthors = json['popularAuthors'] as List? ?? [];

    return DiscoverResponseModel(
      featured: rawFeatured
          .whereType<Map<String, dynamic>>()
          .map((b) => BookModel.fromJson(b))
          .toList(),
      trending: rawTrending
          .whereType<Map<String, dynamic>>()
          .map((b) => BookModel.fromJson(b))
          .toList(),
      newReleases: rawNewReleases
          .whereType<Map<String, dynamic>>()
          .map((b) => BookModel.fromJson(b))
          .toList(),
      popularGenres: rawGenres
          .whereType<Map<String, dynamic>>()
          .map((g) => GenreModel.fromJson(g))
          .toList(),
      popularAuthors: rawAuthors
          .whereType<Map<String, dynamic>>()
          .map((a) => AuthorModel.fromJson(a))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'featured': featured.map((b) => b.toJson()).toList(),
      'trending': trending.map((b) => b.toJson()).toList(),
      'newReleases': newReleases.map((b) => b.toJson()).toList(),
      'popularGenres': popularGenres.map((g) => g.toJson()).toList(),
      'popularAuthors': popularAuthors.map((a) => a.toJson()).toList(),
    };
  }
}
