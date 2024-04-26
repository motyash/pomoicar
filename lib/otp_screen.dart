import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPScreen extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController(); // Контроллер для кода

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
              keyboardType: TextInputType.number, // Только цифры
              inputFormatters: [
                LengthLimitingTextInputFormatter(4), // Ограничение 4 символами
                FilteringTextInputFormatter.allow(RegExp(r'\d+')), // Только цифры
              ],
              decoration: InputDecoration(
                labelText: "Код подтверждения",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String code = _codeController.text;
                // Логика подтверждения кода
                print("Код подтверждения: $code");
              },
              child: Text("Подтвердить"),
            ),
          ],
        ),
      ),
    );
  }
}
