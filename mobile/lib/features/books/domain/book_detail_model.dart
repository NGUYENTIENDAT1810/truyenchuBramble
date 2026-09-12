import 'chapter_model.dart';

class GenreModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? iconName;
  final int booksCount;

  const GenreModel({
    required this.id,
    required this.name,
    this.slug = '',
    this.description,
    this.iconName,
    this.booksCount = 0,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
        return name;
      case 'slug':
        return slug;
      case 'description':
        return description;
      case 'iconName':
        return iconName;
      case 'booksCount':
        return booksCount;
      default:
        return null;
    }
  }

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      description: json['description']?.toString(),
      iconName: json['iconName']?.toString(),
      booksCount: (json['booksCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'iconName': iconName,
      'booksCount': booksCount,
    };
  }
}

class AuthorModel {
  final String id;
  final String name;
  final String? bio;
  final String? avatarUrl;
  final int followersCount;
  final bool isFollowed;
  final int booksCount;
  final List<BookModel> works;

  const AuthorModel({
    required this.id,
    required this.name,
    this.bio,
    this.avatarUrl,
    this.followersCount = 0,
    this.isFollowed = false,
    this.booksCount = 0,
    this.works = const [],
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
        return name;
      case 'bio':
        return bio;
      case 'avatarUrl':
        return avatarUrl;
      case 'followersCount':
        return followersCount;
      case 'isFollowed':
        return isFollowed;
      case 'booksCount':
        return booksCount;
      case 'works':
        return works;
      default:
        return null;
    }
  }

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    final rawWorks = json['works'] as List? ?? [];
    return AuthorModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      bio: json['bio']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      isFollowed: json['isFollowed'] ?? false,
      booksCount: (json['booksCount'] as num?)?.toInt() ?? 0,
      works: rawWorks
          .whereType<Map<String, dynamic>>()
          .map((w) => BookModel.fromJson(w))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'followersCount': followersCount,
      'isFollowed': isFollowed,
      'booksCount': booksCount,
      'works': works.map((w) => w.toJson()).toList(),
    };
  }

  AuthorModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatarUrl,
    int? followersCount,
    bool? isFollowed,
    int? booksCount,
    List<BookModel>? works,
  }) {
    return AuthorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followersCount: followersCount ?? this.followersCount,
      isFollowed: isFollowed ?? this.isFollowed,
      booksCount: booksCount ?? this.booksCount,
      works: works ?? this.works,
    );
  }
}

class BookModel {
  final String id;
  final String title;
  final String slug;
  final String author;
  final String? authorId;
  final String? authorInitial;
  final String? authorAvatarBg;
  final String? authorBio;
  final String? authorNote;
  final String blurb;
  final String coverColor;
  final String coverInkColor;
  final String? coverImageUrl;
  final String tag;
  final List<String> genres;
  final List<GenreModel> genreDetails;
  final double rating;
  final int ratingsCount;
  final int readersCount;
  final int totalChapters;
  final String? badge;
  final String? status;
  final bool isSaved;
  final bool isFeatured;
  final bool isTrending;
  final bool isNewRelease;
  final Map<String, dynamic>? readingProgress;

  const BookModel({
    required this.id,
    required this.title,
    this.slug = '',
    required this.author,
    this.authorId,
    this.authorInitial,
    this.authorAvatarBg,
    this.authorBio,
    this.authorNote,
    this.blurb = '',
    this.coverColor = '#56633f',
    this.coverInkColor = '#f0fae1',
    this.coverImageUrl,
    this.tag = 'Slow fantasy',
    this.genres = const [],
    this.genreDetails = const [],
    this.rating = 4.7,
    this.ratingsCount = 0,
    this.readersCount = 14200,
    this.totalChapters = 0,
    this.badge,
    this.status,
    this.isSaved = false,
    this.isFeatured = false,
    this.isTrending = false,
    this.isNewRelease = false,
    this.readingProgress,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'title':
        return title;
      case 'slug':
        return slug;
      case 'author':
      case 'authorName':
        return author;
      case 'authorId':
        return authorId;
      case 'authorInitial':
        return authorInitial;
      case 'authorAvatarBg':
        return authorAvatarBg;
      case 'authorBio':
        return authorBio;
      case 'authorNote':
        return authorNote;
      case 'blurb':
      case 'description':
        return blurb;
      case 'coverColor':
        return coverColor;
      case 'coverInkColor':
        return coverInkColor;
      case 'coverImageUrl':
      case 'coverUrl':
        return coverImageUrl;
      case 'tag':
        return tag;
      case 'genres':
        return genres;
      case 'genreDetails':
        return genreDetails;
      case 'rating':
        return rating;
      case 'ratingsCount':
        return ratingsCount;
      case 'readersCount':
      case 'viewsCount':
        return readersCount;
      case 'totalChapters':
      case 'chapters':
        return totalChapters;
      case 'badge':
        return badge;
      case 'status':
        return status;
      case 'isSaved':
      case 'inLibrary':
        return isSaved;
      case 'isFeatured':
        return isFeatured;
      case 'isTrending':
        return isTrending;
      case 'isNewRelease':
        return isNewRelease;
      case 'readingProgress':
        return readingProgress;
      default:
        return null;
    }
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final authorValue = json['author'];
    final author = authorValue is Map<String, dynamic>
        ? (authorValue['name'] ?? authorValue['displayName'] ?? '').toString()
        : (authorValue ?? json['authorName'] ?? '').toString();
    final authorMap = authorValue is Map<String, dynamic> ? authorValue : null;

    final rawGenres = json['genres'] as List? ?? [];
    final genreList = rawGenres
        .map((g) => g is Map ? (g['name'] ?? '').toString() : g.toString())
        .toList();

    final rawGenreDetails = json['genreDetails'] as List? ?? [];
    final genreDetails = rawGenreDetails
        .whereType<Map<String, dynamic>>()
        .map((g) => GenreModel.fromJson(g))
        .toList();

    return BookModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      author: author,
      authorId: (json['authorId'] ?? authorMap?['id'])?.toString(),
      authorInitial: (json['authorInitial'] ?? authorMap?['initial'])?.toString(),
      authorAvatarBg: (json['authorAvatarBg'] ?? authorMap?['avatarUrl'])?.toString(),
      authorBio: (json['authorBio'] ?? authorMap?['bio'])?.toString(),
      authorNote: (json['authorNote'] ?? authorMap?['note'])?.toString(),
      blurb: (json['blurb'] ?? json['description'] ?? '').toString(),
      coverColor: (json['coverColor'] ?? '#56633f').toString(),
      coverInkColor: (json['coverInkColor'] ?? '#f0fae1').toString(),
      coverImageUrl: (json['coverImageUrl'] ?? json['coverUrl'])?.toString(),
      tag: (json['tag'] ?? (genreList.isNotEmpty ? genreList.first : 'Slow fantasy')).toString(),
      genres: genreList,
      genreDetails: genreDetails,
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.7,
      ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
      readersCount: (json['readersCount'] ?? json['viewsCount'] ?? 14200) is num
          ? ((json['readersCount'] ?? json['viewsCount'] ?? 14200) as num).toInt()
          : 14200,
      totalChapters: (json['totalChapters'] ?? json['chapters'] ?? 0) is num
          ? ((json['totalChapters'] ?? json['chapters'] ?? 0) as num).toInt()
          : 0,
      badge: json['badge']?.toString(),
      status: json['status']?.toString(),
      isSaved: json['isSaved'] ?? json['inLibrary'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isNewRelease: json['isNewRelease'] ?? false,
      readingProgress: json['readingProgress'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'author': author,
      'authorName': author,
      'authorId': authorId,
      'authorInitial': authorInitial,
      'authorAvatarBg': authorAvatarBg,
      'authorBio': authorBio,
      'authorNote': authorNote,
      'blurb': blurb,
      'description': blurb,
      'coverColor': coverColor,
      'coverInkColor': coverInkColor,
      'coverImageUrl': coverImageUrl,
      'coverUrl': coverImageUrl,
      'tag': tag,
      'genres': genres,
      'genreDetails': genreDetails.map((g) => g.toJson()).toList(),
      'rating': rating,
      'ratingsCount': ratingsCount,
      'readersCount': readersCount,
      'viewsCount': readersCount,
      'totalChapters': totalChapters,
      'badge': badge,
      'status': status,
      'isSaved': isSaved,
      'isFeatured': isFeatured,
      'isTrending': isTrending,
      'isNewRelease': isNewRelease,
      'readingProgress': readingProgress,
    };
  }
}

class BookDetailModel {
  final BookModel book;
  final AuthorModel? author;
  final List<GenreModel> genres;
  final bool inLibrary;
  final String? libraryStatus;
  final int? userProgressPercent;
  final String? lastReadChapterId;
  final int? lastReadChapterNumber;
  final String? lastReadChapterTitle;
  final List<ChapterModel> recentChapters;

  const BookDetailModel({
    required this.book,
    this.author,
    this.genres = const [],
    this.inLibrary = false,
    this.libraryStatus,
    this.userProgressPercent,
    this.lastReadChapterId,
    this.lastReadChapterNumber,
    this.lastReadChapterTitle,
    this.recentChapters = const [],
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'book':
        return book;
      case 'author':
        return author;
      case 'genres':
        return genres;
      case 'inLibrary':
      case 'isSaved':
        return inLibrary;
      case 'libraryStatus':
        return libraryStatus;
      case 'userProgressPercent':
        return userProgressPercent;
      case 'lastReadChapterId':
        return lastReadChapterId;
      case 'lastReadChapterNumber':
        return lastReadChapterNumber;
      case 'lastReadChapterTitle':
        return lastReadChapterTitle;
      case 'recentChapters':
        return recentChapters;
      default:
        return book[key];
    }
  }

  factory BookDetailModel.fromJson(Map<String, dynamic> json) {
    final book = BookModel.fromJson(json);
    final author = json['author'] is Map<String, dynamic>
        ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
        : null;

    final rawGenres = json['genres'] as List? ?? [];
    final genres = rawGenres
        .whereType<Map<String, dynamic>>()
        .map((g) => GenreModel.fromJson(g))
        .toList();

    final rawChapters = json['recentChapters'] as List? ?? [];
    final recentChapters = rawChapters
        .whereType<Map<String, dynamic>>()
        .map((c) => ChapterModel.fromJson(c))
        .toList();

    return BookDetailModel(
      book: book,
      author: author,
      genres: genres,
      inLibrary: json['inLibrary'] ?? json['isSaved'] ?? false,
      libraryStatus: json['libraryStatus']?.toString(),
      userProgressPercent: (json['userProgressPercent'] as num?)?.toInt(),
      lastReadChapterId: json['lastReadChapterId']?.toString(),
      lastReadChapterNumber: (json['lastReadChapterNumber'] as num?)?.toInt(),
      lastReadChapterTitle: json['lastReadChapterTitle']?.toString(),
      recentChapters: recentChapters,
    );
  }
}
