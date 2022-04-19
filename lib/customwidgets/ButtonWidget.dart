import 'package:flutter/material.dart';

//custom widget modreho buttonu ktory pouzivame na obrazovkach
class ButtonWidget extends StatelessWidget {
  final String title;
  final Function onPressed;
  const ButtonWidget(this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SizedBox(
      height: 45,
      width: mediaQuery.size.width - 20,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(title),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF355C7D)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
