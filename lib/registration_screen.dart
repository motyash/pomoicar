import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'target_screen.dart'; // Убедитесь, что импорт правильный

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController(); // Контроллер для имени

  Future<void> _registerUser(BuildContext context) async {
    String userName = _nameController.text;

    if (userName.isEmpty) { // Проверка, что имя не пустое
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Имя не может быть пустым")),
      );
      return; // Если имя пустое, ничего не происходит
    }

    var auth = FirebaseAuth.instance;

    if (auth.currentUser != null) { // Если пользователь аутентифицирован
      try {
        // Сохраняем данные пользователя в Firestore
        await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.uid).set({
          "name": userName,
        });

        // Навигация после успешной регистрации
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TargetScreen(user: auth.currentUser!), // Передаем требуемый параметр
          ),
        );
      } catch (e) { // Обработка ошибок
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка при регистрации: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Регистрация"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Проверьте правильность скобок и запятых
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Введите ваше имя"),
            SizedBox(height: 10), // Убедитесь, что скобки правильно расставлены
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Имя",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10), // Исправлено написание
            ElevatedButton(
              onPressed: () => _registerUser(context), // Обработчик кнопки регистрации
              child: Text("Зарегистрироваться"),
            ),
          ],
        ),
      ),
    );
  }
}
