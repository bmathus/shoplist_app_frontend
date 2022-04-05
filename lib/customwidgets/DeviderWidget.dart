import 'package:flutter/material.dart';

class DeviderWidget extends StatelessWidget {
  final String title;

  const DeviderWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(title),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          thickness: 1,
          color: Colors.white,
        )
      ],
    );
  }
}
