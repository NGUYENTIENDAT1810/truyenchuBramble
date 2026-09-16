import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/books/data/book_repository.dart';
import '../../features/comments/data/comments_repository.dart';
import '../../features/discover/data/discover_repository.dart';
import '../../features/discover/presentation/bloc/discover_bloc.dart';
import '../../features/home/data/home_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/library/data/library_repository.dart';
import '../../features/library/presentation/bloc/library_bloc.dart';
import '../../features/library/presentation/cubit/library_selection_cubit.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/reader/data/reader_repository.dart';
import '../../features/reader/presentation/cubit/reader_settings_cubit.dart';
import '../../features/settings/presentation/cubit/settings_preferences_cubit.dart';
import '../../features/stats/data/stats_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository(sl()));
  sl.registerLazySingleton<DiscoverRepository>(() => DiscoverRepository(sl()));
  sl.registerLazySingleton<BookRepository>(() => BookRepository(sl()));
  sl.registerLazySingleton<LibraryRepository>(() => LibraryRepository(sl()));
  sl.registerLazySingleton<ReaderRepository>(() => ReaderRepository(sl()));
  sl.registerLazySingleton<CommentsRepository>(() => CommentsRepository(sl()));
  sl.registerLazySingleton<StatsRepository>(() => StatsRepository(sl()));

  // Blocs / Cubits
  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(homeRepository: sl()));
  sl.registerFactory<DiscoverBloc>(() => DiscoverBloc(discoverRepository: sl()));
  sl.registerFactory<LibraryBloc>(() => LibraryBloc(libraryRepository: sl()));
  sl.registerFactory<LibrarySelectionCubit>(() => LibrarySelectionCubit());
  sl.registerFactory<ReaderSettingsCubit>(() => ReaderSettingsCubit());
  sl.registerFactory<SettingsPreferencesCubit>(() => SettingsPreferencesCubit());
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit());
}
