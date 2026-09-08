import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../books/domain/book_detail_model.dart';
import '../data/discover_repository.dart';

final discoverRepositoryProvider = Provider<DiscoverRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return DiscoverRepository(client);
});

class DiscoverState {
  final String query;
  final String selectedTag;
  final List<String> tags;
  final List<BookModel> books;
  final bool isLoading;
  final String? errorMessage;

  const DiscoverState({
    this.query = '',
    this.selectedTag = 'All',
    this.tags = const ['All', 'Slow fantasy', 'Progression', 'Literary', 'Court intrigue', 'Epistolary', 'Slipstream'],
    this.books = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  DiscoverState copyWith({
    String? query,
    String? selectedTag,
    List<String>? tags,
    List<BookModel>? books,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DiscoverState(
      query: query ?? this.query,
      selectedTag: selectedTag ?? this.selectedTag,
      tags: tags ?? this.tags,
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class DiscoverController extends StateNotifier<DiscoverState> {
  final DiscoverRepository _repo;

  DiscoverController(this._repo) : super(const DiscoverState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _repo.getDiscoverData();
      final rising = (res['rising'] as List? ?? [])
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final tagsList = (res['tags'] as List? ?? []).map((e) => e.toString()).toList();

      state = state.copyWith(
        books: rising,
        tags: tagsList.isNotEmpty ? tagsList : state.tags,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> setQuery(String q) async {
    state = state.copyWith(query: q);
    await _search();
  }

  Future<void> setTag(String tag) async {
    state = state.copyWith(selectedTag: tag);
    await _search();
  }

  Future<void> _search() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await _repo.searchBooks(
        query: state.query,
        tag: state.selectedTag,
      );
      state = state.copyWith(books: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final discoverControllerProvider =
    StateNotifierProvider.autoDispose<DiscoverController, DiscoverState>((ref) {
  final repo = ref.watch(discoverRepositoryProvider);
  return DiscoverController(repo);
});
