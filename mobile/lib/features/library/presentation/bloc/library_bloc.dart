import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/library_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

export 'library_event.dart';
export 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository _libraryRepository;

  LibraryBloc({required LibraryRepository libraryRepository})
      : _libraryRepository = libraryRepository,
        super(const LibraryInitial(currentTab: 'Reading')) {
    on<LibraryStarted>(_onStarted);
    on<LibraryTabChanged>(_onTabChanged);
    on<LibraryRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    LibraryStarted event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading(currentTab: state.currentTab));
    await _fetchLibrary(state.currentTab, emit);
  }

  Future<void> _onTabChanged(
    LibraryTabChanged event,
    Emitter<LibraryState> emit,
  ) async {
    if (state.currentTab == event.tab && state is LibraryLoaded) return;
    emit(LibraryLoading(currentTab: event.tab));
    await _fetchLibrary(event.tab, emit);
  }

  Future<void> _onRefreshed(
    LibraryRefreshed event,
    Emitter<LibraryState> emit,
  ) async {
    await _fetchLibrary(state.currentTab, emit);
  }

  Future<void> _fetchLibrary(String tab, Emitter<LibraryState> emit) async {
    try {
      final items = await _libraryRepository.getUserLibrary(tab);
      emit(LibraryLoaded(currentTab: tab, items: items));
    } catch (e) {
      emit(LibraryFailure(currentTab: tab, message: e.toString()));
    }
  }
}
