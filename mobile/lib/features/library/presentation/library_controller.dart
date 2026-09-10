import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/library_repository.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return LibraryRepository(client);
});

final currentLibraryTabProvider = StateProvider<String>((ref) => 'Reading');

final libraryListProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final tab = ref.watch(currentLibraryTabProvider);
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.getUserLibrary(tab);
});

class LibrarySelectionState {
  final bool isSelectMode;
  final Set<String> selectedIds;
  final Set<String> downloadingIds;
  final Set<String> downloadedIds;

  const LibrarySelectionState({
    this.isSelectMode = false,
    this.selectedIds = const {},
    this.downloadingIds = const {},
    this.downloadedIds = const {},
  });

  LibrarySelectionState copyWith({
    bool? isSelectMode,
    Set<String>? selectedIds,
    Set<String>? downloadingIds,
    Set<String>? downloadedIds,
  }) {
    return LibrarySelectionState(
      isSelectMode: isSelectMode ?? this.isSelectMode,
      selectedIds: selectedIds ?? this.selectedIds,
      downloadingIds: downloadingIds ?? this.downloadingIds,
      downloadedIds: downloadedIds ?? this.downloadedIds,
    );
  }
}

class LibrarySelectionNotifier extends StateNotifier<LibrarySelectionState> {
  LibrarySelectionNotifier(Ref ref) : super(const LibrarySelectionState()) {
    ref.listen<String>(currentLibraryTabProvider, (previous, next) {
      state = const LibrarySelectionState();
    });
  }

  void toggleSelectMode() {
    state = state.copyWith(isSelectMode: !state.isSelectMode, selectedIds: {});
  }

  void toggleItem(String id) {
    final next = {...state.selectedIds};
    if (!next.add(id)) next.remove(id);
    state = state.copyWith(selectedIds: next);
  }

  Future<void> downloadOne(String id) async {
    if (state.downloadingIds.contains(id) || state.downloadedIds.contains(id)) return;
    state = state.copyWith(downloadingIds: {...state.downloadingIds, id});
    await Future.delayed(const Duration(seconds: 1));
    final downloading = {...state.downloadingIds}..remove(id);
    state = state.copyWith(
      downloadingIds: downloading,
      downloadedIds: {...state.downloadedIds, id},
    );
  }

  Future<void> downloadSelected() async {
    final ids = state.selectedIds.where((id) => !state.downloadedIds.contains(id)).toList();
    for (final id in ids) {
      await downloadOne(id);
    }
  }

  void removeSelected() {
    final downloaded = {...state.downloadedIds}..removeAll(state.selectedIds);
    state = state.copyWith(downloadedIds: downloaded, selectedIds: {});
  }
}

final librarySelectionProvider =
    StateNotifierProvider<LibrarySelectionNotifier, LibrarySelectionState>((ref) {
  return LibrarySelectionNotifier(ref);
});
