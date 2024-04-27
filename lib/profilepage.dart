import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_screen.dart'; // Экран OTP
import 'settings_screen.dart'; // Экран настроек

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const ProfilePage({required this.isDarkMode, required this.toggleTheme});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _phoneController = TextEditingController(text: "+7"); // Начальный телефон
  bool _isButtonEnabled = false;
  FirebaseAuth _auth = FirebaseAuth.instance; // Инициализация Firebase Authentication

  void _onPhoneChanged(String value) {
    if (!value.startsWith("+7")) { // Правильное начало
      _phoneController.text = "+7";
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    }

    setState(() {
      _isButtonEnabled = _phoneController.text.length == 12; // Условие для включения кнопки
    });
  }

  Future<void> _sendCode(BuildContext context) async {
    if (_isButtonEnabled) {
      String phoneNumber = _phoneController.text;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ошибка верификации: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                verificationId: verificationId,
                phone: phoneNumber, // Передаем номер телефона
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings), // Переход в настройки
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
          children: [
            Text(
              'Авторизация по номеру телефона',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12), // Ограничение длины
                FilteringTextInputFormatter.allow(RegExp(r'^\+?\d{0,11}$')), // Только цифры
              ],
              onChanged: _onPhoneChanged,
              decoration: InputDecoration(
                labelText: 'Введите номер телефона',
                border: OutlineInputBorder(), // Граница
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isButtonEnabled ? () => _sendCode(context) : null,
              child: Text('Отправить код подтверждения'),
            ),
          ],
        ),
      ),
    );
  }
}
