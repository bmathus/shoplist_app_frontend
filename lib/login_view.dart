import 'package:flutter/material.dart';
import 'customwidgets/textfieldwidget.dart';
import 'customwidgets/buttonwidget.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFieldWidget(
              hintText: 'Email',
              hideText: false,
              leftIcon: Icons.mail_outline,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              hintText: 'Password',
              hideText: false,
              leftIcon: Icons.lock_outline,
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              title: 'Login',
              hasBorder: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
