import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'models/UserAuth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthUser user = AuthUser();
  bool loading = true;
  bool homeView = true;

  void chooseView() async {
    homeView = await user.tryAutoLogin();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    chooseView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: loading
          ? Scaffold()
          : homeView
              ? HomeView(
                  user: user,
                  lists: ShopLists(token: user.token),
                )
              : LoginView(user: user),
    );
  }
}
