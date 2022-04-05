import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 77,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 59, 58, 58),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF355C7D)),
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
            children: const [
              Text(
                "Matus",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("bojko.matus@gmail.com"),
            ],
          )
        ],
      ),
    );
  }
}
