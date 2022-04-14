import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Participant.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'package:shoplist_project/models/UserAuth.dart';
import 'customwidgets/DeviderWidget.dart';
import 'package:flutter/services.dart';

class ParticipantsView extends StatelessWidget {
  final AuthUser user;
  final List<Participant> participants;
  final String invite_code;

  ParticipantsView({
    required this.user,
    required this.participants,
    required this.invite_code,
  });

  Widget getParticipantWidget(String name, String email, bool me) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 43, 43, 43),
        border: Border(
          top: BorderSide(color: Color.fromARGB(66, 255, 255, 255), width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(email),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(name),
        ),
        trailing: me
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VerticalDivider(
                    indent: 0,
                    endIndent: 0,
                    color: Color.fromARGB(66, 255, 255, 255),
                    thickness: 1,
                    width: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: IconButton(
                      icon: const Icon(Icons.phone, size: 28),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> getParticpantsListUI() {
    Widget owner = SizedBox();
    List<Widget> participList = participants.map((participant) {
      if (participant.id == user.id) {
        owner = getParticipantWidget(
            "${participant.name} (You)", participant.email, true);
        return SizedBox();
      } else {
        return getParticipantWidget(participant.name, participant.email, false);
      }
    }).toList();

    participList.insert(0, owner);
    participList.insert(0, const DeviderWidget("Participants"));
    participList.insert(0, const SizedBox(height: 10));

    participList.add(const Divider(
      color: Color.fromARGB(66, 255, 255, 255),
      thickness: 1,
      height: 0,
    ));
    return participList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(children: getParticpantsListUI()),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 59, 58, 58),
              border: Border.all(color: Colors.black26)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Invite users with this code:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(invite_code),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: invite_code));
                },
                child: const Text("Copy code"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF355C7D)),
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
