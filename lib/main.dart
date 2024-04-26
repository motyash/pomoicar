import 'package:flutter/material.dart';
import 'mainscreen.dart'; // предположим что `MainScreen` в отдельном файле

void main() => runApp(Pomoikar());

class Pomoikar extends StatefulWidget {
  @override
  _PomoikarState createState() => _PomoikarState();
}

class _PomoikarState extends State<Pomoikar> {
  bool _isDarkMode = false; // Состояние для хранения текущего режима

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Переключение режима
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Используем темную или светлую тему
      home: MainScreen(
        isDarkMode: _isDarkMode, // Передаем текущее состояние темы
        toggleTheme: _toggleTheme, // Передаем функцию для переключения
      ),
    );
  }
}
