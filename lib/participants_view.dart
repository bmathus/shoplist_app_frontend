import 'package:flutter/material.dart';
import 'customwidgets/DeviderWidget.dart';

class ParticipantsView extends StatelessWidget {
  const ParticipantsView();

  @override
  Widget build(BuildContext context) {
    Widget participantWidget = Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 43, 43, 43),
        border: Border(
          top: BorderSide(color: Color.fromARGB(66, 255, 255, 255), width: 1),
        ),
      ),
      child: ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.zero,
        title: Text("User info"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VerticalDivider(
              indent: 5,
              endIndent: 5,
              color: Color.fromARGB(66, 255, 255, 255),
              thickness: 1,
              width: 0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              DeviderWidget("Participants"),
              participantWidget
            ],
          ),
        ),
      ],
    );
  }
}
