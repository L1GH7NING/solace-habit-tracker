import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/core/providers/theme_provider.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/local/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const ZenithApp(),
    ),
  );
}

class ZenithApp extends StatelessWidget {
  const ZenithApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 THEME: Wrap the MaterialApp with a Consumer to listen for theme changes.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,

          // 👇 These three lines enable the theme toggle
          theme: AppTheme.lightTheme,         // Set the light theme
          darkTheme: AppTheme.darkTheme,        // Set the dark theme
          themeMode: themeProvider.themeMode,   // Get the current mode from the provider
          
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}