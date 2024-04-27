import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration_screen.dart'; // Импорт экрана регистрации

class OTPScreen extends StatelessWidget {
  final String verificationId;
  final String phone;
  final TextEditingController _codeController = TextEditingController(); // Контроллер для кода

  OTPScreen({required this.verificationId, required this.phone}); // Конструктор принимает телефон

  Future<void> _verifyCode(BuildContext context) async {
    String code = _codeController.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationScreen(phone: phone), // Передаем телефон
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при верификации кода")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Подтверждение кода"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Отступы
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Введите код, который вы получили.",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _codeController, // Поле для кода
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(6), // 6-значный код
                FilteringTextInputFormatter.allow(RegExp(r'\d+')),
              ],
              decoration: InputDecoration(
                labelText: "Код подтверждения",
                border: OutlineInputBorder(), // Граница
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _verifyCode(context),
              child: Text("Подтвердить"),
            ),
          ],
        ),
      ),
    );
  }
}
