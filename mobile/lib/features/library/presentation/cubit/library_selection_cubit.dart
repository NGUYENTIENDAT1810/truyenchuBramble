import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibrarySelectionState extends Equatable {
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

  @override
  List<Object?> get props => [
        isSelectMode,
        selectedIds,
        downloadingIds,
        downloadedIds,
      ];
}

class LibrarySelectionCubit extends Cubit<LibrarySelectionState> {
  LibrarySelectionCubit() : super(const LibrarySelectionState());

  void reset() {
    emit(const LibrarySelectionState());
  }

  void toggleSelectMode() {
    emit(state.copyWith(
      isSelectMode: !state.isSelectMode,
      selectedIds: {},
    ));
  }

  void toggleItem(String id) {
    final next = {...state.selectedIds};
    if (!next.add(id)) next.remove(id);
    emit(state.copyWith(selectedIds: next));
  }

  Future<void> downloadOne(String id) async {
    if (state.downloadingIds.contains(id) || state.downloadedIds.contains(id)) return;
    emit(state.copyWith(downloadingIds: {...state.downloadingIds, id}));
    await Future.delayed(const Duration(seconds: 1));
    final downloading = {...state.downloadingIds}..remove(id);
    emit(state.copyWith(
      downloadingIds: downloading,
      downloadedIds: {...state.downloadedIds, id},
    ));
  }

  Future<void> downloadSelected() async {
    final ids = state.selectedIds.where((id) => !state.downloadedIds.contains(id)).toList();
    for (final id in ids) {
      await downloadOne(id);
    }
  }

  void removeSelected() {
    final downloaded = {...state.downloadedIds}..removeAll(state.selectedIds);
    emit(state.copyWith(downloadedIds: downloaded, selectedIds: {}));
  }
}
