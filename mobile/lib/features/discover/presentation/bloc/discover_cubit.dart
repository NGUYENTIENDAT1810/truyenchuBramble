import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/discover_repository.dart';
import 'discover_state.dart';

export 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final DiscoverRepository _discoverRepository;

  DiscoverCubit({required DiscoverRepository discoverRepository})
      : _discoverRepository = discoverRepository,
        super(const DiscoverState());

  Future<void> started() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    await _loadInitial();
  }

  Future<void> refreshed() async {
    await _searchOrInitial();
  }

  Future<void> queryChanged(String query) async {
    emit(state.copyWith(query: query, isLoading: true, errorMessage: null));
    await _searchOrInitial();
  }

  Future<void> tagSelected(String tag) async {
    emit(state.copyWith(selectedTag: tag, isLoading: true, errorMessage: null));
    await _searchOrInitial();
  }

  Future<void> _loadInitial() async {
    try {
      final res = await _discoverRepository.getDiscoverData();
      final allBooks =
          await _discoverRepository.searchBooks(query: '', tag: 'All');

      final tagsList = ['All', ...res.popularGenres.map((g) => g.name)];
      emit(state.copyWith(
        books: allBooks,
        tags: tagsList.length > 1 ? tagsList : state.tags,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _searchOrInitial() async {
    if (state.query.isEmpty && state.selectedTag == 'All') {
      await _loadInitial();
      return;
    }

    try {
      final results = await _discoverRepository.searchBooks(
        query: state.query,
        tag: state.selectedTag,
      );
      emit(state.copyWith(books: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
