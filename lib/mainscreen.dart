import 'package:flutter/material.dart';
import 'profilepage.dart'; // Подключаем обновленный раздел "Профиль"

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const MainScreen({required this.isDarkMode, required this.toggleTheme});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      // Добавляем текст "Добро пожаловать, пользователь!" на главную страницу
      Padding(
        padding: EdgeInsets.only(left: 30.0, top: 60.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Добро пожаловать, пользователь!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Text('Поиск'),
      Text('Карта'),
      ProfilePage(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Обновляем индекс выбранной вкладки
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PomoiCAR'),
      ),
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex), // Отображаем текущую вкладку
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная', // Помещаем новый текст в главную
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Карта',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped, // Обработчик нажатия
      ),
    );
  }
}
