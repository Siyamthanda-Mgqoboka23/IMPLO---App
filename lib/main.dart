import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFE0FDF9),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ImpiloApp());
}

class ImpiloApp extends StatelessWidget {
  const ImpiloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impilo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: null,
        scaffoldBackgroundColor: const Color(0xFFE0FDF9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0DBFB0),
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}