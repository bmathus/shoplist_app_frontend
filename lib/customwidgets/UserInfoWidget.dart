import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoplist_project/views/home_view.dart';
import 'package:shoplist_project/views/login_view.dart';
import 'package:shoplist_project/models/UserAuth.dart';

class UserInfoWidget extends StatelessWidget {
  final AuthUser user;
  const UserInfoWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    void logout() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      print("email pri loggout ${user.email}");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => LoginView(user: user),
        ),
      );
    }

    return Container(
      height: 77,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 59, 58, 58),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black26, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/profile_icon.png',
            height: 65,
            width: 65,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(user.email),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () => logout(),
            child: Text("Log-out"),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 104, 59, 64)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
