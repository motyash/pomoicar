import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration_screen.dart'; // Импортируем экран регистрации

class OTPScreen extends StatelessWidget {
  final String verificationId;
  final TextEditingController _codeController = TextEditingController();

  OTPScreen({required this.verificationId});

  Future<void> _verifyCode(BuildContext context) async {
    String code = _codeController.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Переходим на экран регистрации после успешной верификации
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при проверке кода")),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Введите код, который вы получили.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(6), // 6-значный код
                FilteringTextInputFormatter.allow(RegExp(r'\d+')),
              ],
              decoration: InputDecoration(
                labelText: "Код подтверждения",
                border: OutlineInputBorder(),
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
