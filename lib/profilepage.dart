import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Импорт для TextInputFormatter
import 'package:firebase_auth/firebase_auth.dart'; // Импорт Firebase Authentication
import 'otp_screen.dart'; // Экран для ввода кода подтверждения
import 'settings_screen.dart'; // Экран настроек

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const ProfilePage({required this.isDarkMode, required this.toggleTheme});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _phoneController = TextEditingController(text: "+7"); // Контроллер с фиксированным кодом страны
  bool _isButtonEnabled = false; // Состояние кнопки отправки
  FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication

  void _onPhoneChanged(String value) {
    if (!value.startsWith("+7")) { // Используйте `startsWith` вместо `starts_with`
      _phoneController.text = "+7"; // Установите значение с кодом страны
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    }

    setState(() {
      _isButtonEnabled = _phoneController.text.length == 12; // Правильное значение
    });
  }

  Future<void> _sendCode(BuildContext context) async {
    if (_isButtonEnabled) {
      String phoneNumber = _phoneController.text; // Используем правильное имя переменной

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber, // Передаем правильное значение
        timeout: Duration(seconds: 60), // Таймаут ожидания
        verificationCompleted: (PhoneAuthCredential credential) { // При успешной верификации
          _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) { // Обработка ошибок
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ошибка верификации: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) { // Когда код отправлен
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(verificationId: verificationId), // Передаем verificationId
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) { // При таймауте автоматической верификации
          // Дополнительная логика при таймауте
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings), // Кнопка перехода в настройки
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(
                  isDarkMode: widget.isDarkMode,
                  toggleTheme: widget.toggleTheme,
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Отступы
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Авторизация по номеру телефона',
              style: TextStyle(fontSize: 24), // Стиль текста
            ),
            SizedBox(height: 10), // Отступ
            TextField(
              controller: _phoneController, // Используем правильный контроллер
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12), // Ограничение длины ввода
                FilteringTextInputFormatter.allow(RegExp(r'^\+?\d{0,11}$')), // Только цифры
              ],
              onChanged: _onPhoneChanged, // Обработка изменений в телефоне
              decoration: InputDecoration(
                labelText: 'Введите номер телефона', // Метка ввода
                border: OutlineInputBorder(), // Граница
              ),
            ),
            SizedBox(height: 10), // Отступ
            ElevatedButton(
              onPressed: _isButtonEnabled ? () => _sendCode(context) : null, // Кнопка отправки кода
              child: Text('Отправить код подтверждения'), // Текст кнопки
            ),
          ],
        ),
      ),
    );
  }
}

