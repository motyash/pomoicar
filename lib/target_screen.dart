import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TargetScreen extends StatelessWidget {
  final User user;

  TargetScreen({required this.user}); // Получаем текущего пользователя

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"), // Название экрана
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("users").doc(user.uid).get(), // Получение данных из Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Показ индикатора загрузки
          }

          if (snapshot.hasError) {
            return Center(child: Text("Ошибка загрузки данных")); // Обработка ошибок
          }

          var userData = snapshot.data?.data() as Map<String, dynamic>?; // Преобразуем данные к Map
          return userData != null
              ? Center(
            child: Text(
              "Имя: ${userData['name'] ?? 'Не указано'}", // Отображение имени
              style: TextStyle(fontSize: 24),
            ),
          )
              : Center(child: Text("Данные не найдены")); // Если данных нет
        },
      ),
    );
  }
}
