import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/bramble_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/books/data/book_repository.dart';
import 'features/comments/data/comments_repository.dart';
import 'features/discover/data/discover_repository.dart';
import 'features/discover/presentation/bloc/discover_bloc.dart';
import 'features/home/data/home_repository.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/library/data/library_repository.dart';
import 'features/library/presentation/bloc/library_bloc.dart';
import 'features/library/presentation/cubit/library_selection_cubit.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'features/reader/data/reader_repository.dart';
import 'features/reader/presentation/cubit/reader_settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_preferences_cubit.dart';
import 'features/stats/data/stats_repository.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local persistent storage
  await LocalStorage.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final apiClient = ApiClient();

  runApp(BrambleRootApp(apiClient: apiClient));
}

class BrambleRootApp extends StatelessWidget {
  final ApiClient apiClient;

  const BrambleRootApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>.value(value: apiClient),
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(apiClient),
        ),
        RepositoryProvider<HomeRepository>(
          create: (_) => HomeRepository(apiClient),
        ),
        RepositoryProvider<DiscoverRepository>(
          create: (_) => DiscoverRepository(apiClient),
        ),
        RepositoryProvider<BookRepository>(
          create: (_) => BookRepository(apiClient),
        ),
        RepositoryProvider<LibraryRepository>(
          create: (_) => LibraryRepository(apiClient),
        ),
        RepositoryProvider<ReaderRepository>(
          create: (_) => ReaderRepository(apiClient),
        ),
        RepositoryProvider<CommentsRepository>(
          create: (_) => CommentsRepository(apiClient),
        ),
        RepositoryProvider<StatsRepository>(
          create: (_) => StatsRepository(apiClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(const AuthCheckRequested()),
          ),
          BlocProvider<ReaderSettingsCubit>(
            create: (_) => ReaderSettingsCubit(),
          ),
          BlocProvider<SettingsPreferencesCubit>(
            create: (_) => SettingsPreferencesCubit(),
          ),
          BlocProvider<NotificationsCubit>(
            create: (_) => NotificationsCubit(),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              homeRepository: context.read<HomeRepository>(),
            ),
          ),
          BlocProvider<DiscoverBloc>(
            create: (context) => DiscoverBloc(
              discoverRepository: context.read<DiscoverRepository>(),
            ),
          ),
          BlocProvider<LibraryBloc>(
            create: (context) => LibraryBloc(
              libraryRepository: context.read<LibraryRepository>(),
            ),
          ),
          BlocProvider<LibrarySelectionCubit>(
            create: (_) => LibrarySelectionCubit(),
          ),
        ],
        child: const BrambleApp(),
      ),
    );
  }
}

class BrambleApp extends StatefulWidget {
  const BrambleApp({super.key});

  @override
  State<BrambleApp> createState() => _BrambleAppState();
}

class _BrambleAppState extends State<BrambleApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    _router = AppRouter.createRouter(authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bramble',
      debugShowCheckedModeBanner: false,
      theme: BrambleTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
