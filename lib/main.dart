import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final status = await Permission.location.request();
  if (!status.isGranted) {
    debugPrint('Użytkownik nie przyznał uprawnień do lokalizacji.');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nawigacja UP',
      theme: AppTheme.themeData,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
