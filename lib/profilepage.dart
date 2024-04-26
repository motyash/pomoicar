import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Импорт для TextInputFormatter
import 'settings_screen.dart';
import 'otp_screen.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const ProfilePage({required this.isDarkMode, required this.toggleTheme});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _phoneController = TextEditingController(text: "+7"); // Фиксированный код страны
  bool _isButtonEnabled = false; // Состояние кнопки

  void _onPhoneChanged(String value) {
    if (!value.startsWith("+7")) { // Используем правильный синтаксис
      _phoneController.text = "+7";
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    }

    setState(() {
      _isButtonEnabled = _phoneController.text.length == 12; // Исправлено на верный контроллер
    });
  }

  void _sendCode() {
    if (_isButtonEnabled) {
      print("Отправка кода на номер: ${_phoneController.text}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(), // Переход на экран OTP
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Авторизация по номеру телефона',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController, // Исправлено на правильный контроллер
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12), // Ограничение 12 символами
                FilteringTextInputFormatter.allow(RegExp(r'^\+?\d{0,11}$')), // Только цифры
              ],
              onChanged: _onPhoneChanged,
              decoration: InputDecoration(
                labelText: 'Введите номер телефона',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _sendCode : null,
              child: Text('Отправить код подтверждения'),
            ),
          ],
        ),
      ),
    );
  }
}
