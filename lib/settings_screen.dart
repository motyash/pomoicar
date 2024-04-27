import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function toggleTheme; // Принимаем функцию переключения темы

  const SettingsScreen({required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => toggleTheme(), // Переключение темного режима
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? Colors.transparent : Colors.yellow,
                  border: Border.all(
                    color: isDarkMode ? Colors.grey : Colors.yellow,
                    width: 2,
                  ),
                ),
                width: 50,
                height: 50,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: isDarkMode ? 0.3 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.lightbulb,
                      color: isDarkMode ? Colors.grey : Colors.yellow,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
