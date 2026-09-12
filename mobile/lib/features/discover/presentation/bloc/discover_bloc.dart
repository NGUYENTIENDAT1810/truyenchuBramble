import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/discover_repository.dart';
import 'discover_event.dart';
import 'discover_state.dart';

export 'discover_event.dart';
export 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository _discoverRepository;

  DiscoverBloc({required DiscoverRepository discoverRepository})
      : _discoverRepository = discoverRepository,
        super(const DiscoverState()) {
    on<DiscoverStarted>(_onStarted);
    on<DiscoverQueryChanged>(_onQueryChanged);
    on<DiscoverTagSelected>(_onTagSelected);
    on<DiscoverRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    DiscoverStarted event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    await _loadInitial(emit);
  }

  Future<void> _onRefreshed(
    DiscoverRefreshed event,
    Emitter<DiscoverState> emit,
  ) async {
    await _searchOrInitial(emit);
  }

  Future<void> _onQueryChanged(
    DiscoverQueryChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(
        query: event.query, isLoading: true, errorMessage: null));
    await _searchOrInitial(emit);
  }

  Future<void> _onTagSelected(
    DiscoverTagSelected event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(
        selectedTag: event.tag, isLoading: true, errorMessage: null));
    await _searchOrInitial(emit);
  }

  Future<void> _loadInitial(Emitter<DiscoverState> emit) async {
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

  Future<void> _searchOrInitial(Emitter<DiscoverState> emit) async {
    if (state.query.isEmpty && state.selectedTag == 'All') {
      await _loadInitial(emit);
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
