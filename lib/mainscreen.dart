import 'package:flutter/material.dart';
import 'profilepage.dart';
import 'firebase_helper.dart'; // Импорт функции для работы с Firebase

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
      _buildSearchWidget(), // Виджет для поиска пользователей
      Text('Карта'),
      ProfilePage(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Обновляем выбранный индекс
    });
  }

  Widget _buildSearchWidget() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchUsersFromFirebase(), // Получение данных из Firebase Realtime Database
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Индикатор загрузки
        }

        if (snapshot.hasError) {
          return Center(child: Text("Ошибка загрузки")); // Обработка ошибок
        }

        var users = snapshot.data ?? []; // Список пользователей

        return ListView.builder(
          itemCount: users.length, // Количество элементов
          itemBuilder: (context, index) {
            var user = users[index]; // Данные о пользователе
            return ListTile(
              title: Text(user['name'] ?? 'Без имени'), // Имя
              subtitle: Text(user['phone'] ?? 'Нет телефона'), // Телефон
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PomoiCAR'),
      ),
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex), // Текущий виджет
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
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
