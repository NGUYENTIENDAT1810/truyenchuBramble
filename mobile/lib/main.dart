import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection_container.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/bramble_theme.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/discover/presentation/bloc/discover_cubit.dart';
import 'features/home/presentation/bloc/home_cubit.dart';
import 'features/library/presentation/bloc/library_cubit.dart';
import 'features/library/presentation/cubit/library_selection_cubit.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'features/reader/presentation/cubit/reader_settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_preferences_cubit.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local persistent storage
  await LocalStorage.init();

  // Register dependencies (get_it)
  await initDependencyInjection();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BrambleRootApp());
}

class BrambleRootApp extends StatelessWidget {
  const BrambleRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkRequested(),
        ),
        BlocProvider<ReaderSettingsCubit>(create: (_) => sl<ReaderSettingsCubit>()),
        BlocProvider<SettingsPreferencesCubit>(create: (_) => sl<SettingsPreferencesCubit>()),
        BlocProvider<NotificationsCubit>(create: (_) => sl<NotificationsCubit>()),
        BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
        BlocProvider<DiscoverCubit>(create: (_) => sl<DiscoverCubit>()),
        BlocProvider<LibraryCubit>(create: (_) => sl<LibraryCubit>()),
        BlocProvider<LibrarySelectionCubit>(create: (_) => sl<LibrarySelectionCubit>()),
      ],
      child: const BrambleApp(),
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
    final authCubit = context.read<AuthCubit>();
    _router = AppRouter.createRouter(authCubit);
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
