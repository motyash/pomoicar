import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Импорт конфигурации Firebase
import 'mainscreen.dart'; // Экран после инициализации

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Инициализация Flutter

  // Обработка возможных ошибок при инициализации Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Ошибка при инициализации Firebase: $e");
    // Вывод сообщения об ошибке или другое действие
  }

  runApp(Pomoikar());
}

class Pomoikar extends StatefulWidget {
  @override
  _PomoikarState createState() => _PomoikarState();
}

class _PomoikarState extends State<Pomoikar> {
  bool _isDarkMode = false; // Инициализация переменной

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Переключение между темами
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainScreen(
        isDarkMode: _isDarkMode, // Передаем значение переменной
        toggleTheme: _toggleTheme, // Передаем функцию переключения
      ),
    );
  }
}
