import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

// Firebase設定
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyAJ9g45GB_qArdCsUKSG0BIzCXUiS9RndQ",
      authDomain: "mangatranslatorapp.firebaseapp.com",
      projectId: "mangatranslatorapp",
      storageBucket: "mangatranslatorapp.firebasestorage.app",
      messagingSenderId: "1064051585595",
      appId: "1:1064051585595:web:8ec3db9d653652b75ca21e",
      measurementId: "G-G97GW0E0DY",
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MangaTranslatorApp());
}

class MangaTranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '漫画語学学習アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[700],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(secondary: Colors.amber[600]),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
          fontSizeFactor: 0.9, // 少し大きめ
        ),
        iconTheme: IconThemeData(
          size: 24, // 標準サイズ
          color: Colors.blue[700],
        ),
      ),
      home: HomeScreen(),
    );
  }
}
