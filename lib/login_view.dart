import 'package:flutter/material.dart';
import 'package:shoplist_project/home_view.dart';
import 'customwidgets/TextfieldWidget.dart';
import 'customwidgets/LoginButtonWidget.dart';

class LoginView extends StatelessWidget {
  void gotoHomeView(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => HomeView(),
      ),
    );
  }

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
              onTap: () => gotoHomeView(context),
            ),
          ],
        ),
      ),
    );
  }
}
