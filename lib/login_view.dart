import 'package:flutter/material.dart';
import 'package:shoplist_project/home_view.dart';
import 'customwidgets/LoginTextfieldWidget.dart';
import 'customwidgets/LoginButtonWidget.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void gotoHomeView(BuildContext ctx) {
    Navigator.of(ctx)
        .push(
          MaterialPageRoute(
            builder: (ctx) => HomeView(),
          ),
        )
        .then((value) => setState(() {
              emailController.text = "";
              passwordController.text = "";
              FocusManager.instance.primaryFocus?.unfocus();
            }));
  }

  @override
  Widget build(BuildContext context) {
    print("buildujem login");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFieldWidget(
              controller: emailController,
              hintText: 'Email',
              hideText: false,
              leftIcon: Icons.mail_outline,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              controller: passwordController,
              hintText: 'Password',
              hideText: true,
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
