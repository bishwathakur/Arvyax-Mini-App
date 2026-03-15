import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'data/providers.dart';
import 'router.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive Persistence manually without generator conflicts
  await Hive.initFlutter();
  
  final container = ProviderContainer();
  // Init repositories explicitly
  await container.read(journalRepositoryProvider).init();
  await container.read(sessionRepositoryProvider).init();
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ArvyaXApp(),
    ),
  );
}

class ArvyaXApp extends StatelessWidget {
  const ArvyaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ArvyaX Mini',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
