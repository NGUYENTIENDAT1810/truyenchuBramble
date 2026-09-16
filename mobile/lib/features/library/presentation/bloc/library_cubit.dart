import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/library_repository.dart';
import 'library_state.dart';

export 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LibraryRepository _libraryRepository;

  LibraryCubit({required LibraryRepository libraryRepository})
      : _libraryRepository = libraryRepository,
        super(const LibraryInitial(currentTab: 'Reading'));

  Future<void> started() async {
    emit(LibraryLoading(currentTab: state.currentTab));
    await _fetchLibrary(state.currentTab);
  }

  Future<void> tabChanged(String tab) async {
    if (state.currentTab == tab && state is LibraryLoaded) return;
    emit(LibraryLoading(currentTab: tab));
    await _fetchLibrary(tab);
  }

  Future<void> refreshed() async {
    await _fetchLibrary(state.currentTab);
  }

  Future<void> _fetchLibrary(String tab) async {
    try {
      final items = await _libraryRepository.getUserLibrary(tab);
      emit(LibraryLoaded(currentTab: tab, items: items));
    } catch (e) {
      emit(LibraryFailure(currentTab: tab, message: e.toString()));
    }
  }
}
