import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'target_screen.dart'; // Экран после успешной регистрации
import 'firebase_helper.dart'; // Импортируем файл с функцией `addUserToFirebase`

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final String phone;

  RegistrationScreen({required this.phone});

  Future<void> _registerUser(BuildContext context) async {
    var auth = FirebaseAuth.instance;

    if (auth.currentUser == null) { // Если пользователь не авторизован
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Пользователь не авторизован")),
      );
      return;
    }

    String userName = _nameController.text;

    if (userName.isEmpty) { // Если имя пустое
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Имя не может быть пустым")),
      );
      return;
    }

    try {
      await addUserToFirebase(auth.currentUser!.uid, userName, phone); // Сохраняем данные в Firebase

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Пользователь зарегистрирован")),
      );

      // Переход к целевому экрану после регистрации
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TargetScreen(user: auth.currentUser!), // Передаем текущего пользователя
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при регистрации: ${e.toString()}")), // Обратная связь при ошибке
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Регистрация"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Введите ваше имя",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Имя",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _registerUser(context), // Обработчик кнопки
              child: Text("Зарегистрироваться"),
            ),
          ],
        ),
      ),
    );
  }
}
