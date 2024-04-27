import 'package:firebase_database/firebase_database.dart';

// Функция для добавления пользователя в Firebase Realtime Database
Future<void> addUserToFirebase(String uid, String userName, String phone) async {
  final databaseReference = FirebaseDatabase.instance.ref(); // Ссылка на корень Realtime Database

  await databaseReference.child("users/$uid").set({
    'name': userName,
    'phone': phone,
    'uid': uid,
  });
}

// Функция для получения всех пользователей из Firebase Realtime Database
Future<List<Map<String, dynamic>>> fetchUsersFromFirebase() async {
  final databaseReference = FirebaseDatabase.instance.ref(); // Ссылка на корень Realtime Database
  final snapshot = await databaseReference.child("users").get(); // Получаем данные из узла "users"

  if (!snapshot.exists) {
    throw Exception("Users not found"); // Если нет данных
  }

  // Преобразуем данные в список карт
  List<Map<String, dynamic>> users = [];
  snapshot.children.forEach((child) {
    users.add({
      'uid': child.key, // UID пользователя
      'name': child.child("name").value, // Имя пользователя
      'phone': child.child("phone").value, // Номер телефона
    });
  });

  return users; // Возвращаем список пользователей
}

// Функция для обновления данных о пользователе в Firebase Realtime Database
Future<void> updateUserInFirebase(String uid, String userName, String phone) async {
  final databaseReference = FirebaseDatabase.instance.ref(); // Ссылка на корень Realtime Database

  await databaseReference.child("users/$uid").update({
    'name': userName, // Обновляем имя
    'phone': phone, // Обновляем номер телефона
  });
}

// Функция для удаления пользователя из Firebase Realtime Database
Future<void> deleteUserFromFirebase(String uid) async {
  final databaseReference = FirebaseDatabase.instance.ref(); // Ссылка на корень Realtime Database

  await databaseReference.child("users/$uid").remove(); // Удаляем пользователя
}
