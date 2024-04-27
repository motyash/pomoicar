import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:firebase_core/firebase_core.dart'; // Импорт Firebase Core
import 'firebase_options.dart'; // Опции Firebase, сгенерированные при настройке
import 'mainscreen.dart'; // Предположим, что `MainScreen` в отдельном файле
>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Убедиться, что сервисы Flutter готовы
  await Firebase.initializeApp( // Инициализация Firebase
    options: DefaultFirebaseOptions.currentPlatform, // Используем опции из файла конфигурации
  );

  runApp(Pomoikar()); // Запуск вашего приложения
}

class Pomoikar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Раздел 1'),
    Text('Раздел 2'),
    Text('Раздел 3'),
    Text('Раздел 4'),
    Text('Раздел 5'),
  ];

  void _onItemTapped(int index) {
    setState(() {
<<<<<<< Updated upstream
      _selectedIndex = index;
=======
      _isDarkMode = !_isDarkMode; // Переключение между режимами
>>>>>>> Stashed changes
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomoikar'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Это позволяет видеть все иконки, даже когда они не активны
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Уведомления',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
=======
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Используем темную или светлую тему
      home: MainScreen(
        isDarkMode: _isDarkMode, // Передаем текущее состояние
        toggleTheme: _toggleTheme, // Передаем функцию переключения
>>>>>>> Stashed changes
      ),
    );
  }
}
