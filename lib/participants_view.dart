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
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("User info"),
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 2),
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 59, 58, 58),
              border: Border.all(color: Colors.black26)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Invite users with this code:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text("iufdsaijnjnkfdsonjdss"),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {},
                child: Text("Copy code"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF355C7D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
