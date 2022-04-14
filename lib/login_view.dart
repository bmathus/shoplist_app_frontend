import 'package:flutter/material.dart';
import 'package:shoplist_project/home_view.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'customwidgets/LoginTextfieldWidget.dart';
import 'customwidgets/LoginButtonWidget.dart';
import 'package:shoplist_project/models/UserAuth.dart';

class LoginView extends StatefulWidget {
  final AuthUser user;
  LoginView({required this.user});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool validatingLogin = false;
  bool validationError = false;

  void loginPressed(BuildContext ctx) async {
    setState(() {
      validatingLogin = true;
      validationError = false;
    });
    try {
      await widget.user.login(
          email: emailController.text, password: passwordController.text);
      gotoHomeView();
    } on Exception catch (e) {
      if (e.toString() == "Exception: Unauthorized") {
        validationError = true;
      } else if (e.toString() == "Exception: No connection") {
        validationError = false;
        widget.user.showErrorDialog("No connection", ctx);
      } else {
        validationError = false;
        widget.user.showErrorDialog("Something went wrong", ctx);
      }
    }
    setState(() {
      validatingLogin = false;
    });
  }

  void gotoHomeView() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => HomeView(
          user: widget.user,
          lists: ShopLists(token: widget.user.token),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.3,
                child: Image.asset(
                  "applogo.png",
                )),
            const SizedBox(
              height: 50,
            ),
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
              height: 10,
            ),
            validationError
                ? const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Incorrect email or password",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            validatingLogin
                ? CircularProgressIndicator()
                : ButtonWidget(
                    title: 'Login',
                    hasBorder: false,
                    onTap: () => loginPressed(context),
                  ),
          ],
        ),
      ),
    );
  }
}
