import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/local/app_database.dart';

// 🗑️ REMOVED the global: final db = AppDatabase(); 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // ⚡ Initialize the database ONCE right as the app starts
  final database = AppDatabase();

  runApp(
    // 🛠️ MultiProvider lets you give your app multiple pieces of global data
    MultiProvider(
      providers: [
        // 1. Provide the Database (Use standard Provider because it doesn't need to notify UI of changes)
        Provider<AppDatabase>.value(value: database),
        
        // 2. Provide the User State (Use ChangeNotifierProvider because it updates the UI)
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}