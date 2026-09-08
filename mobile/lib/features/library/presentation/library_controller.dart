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
