import 'package:flutter/material.dart';
import 'package:shoplist_project/views/home_view.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import '../customwidgets/LoginTextfieldWidget.dart';
import '../customwidgets/LoginButtonWidget.dart';
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
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    "1.png",
                    fit: BoxFit.cover,
                    color: Color(0xFF355C7D),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  height: 200,
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Shoplist App',
                    style: TextStyle(
                      color: Color.fromARGB(184, 255, 255, 255),
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30, right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    ? CircularProgressIndicator(
                        color: Color(0xFF355C7D),
                      )
                    : ButtonWidget(
                        title: 'Login',
                        hasBorder: false,
                        onTap: () => loginPressed(context),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
