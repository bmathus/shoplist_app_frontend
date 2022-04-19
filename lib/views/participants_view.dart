import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Participant.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shoplist_project/models/UserAuth.dart';
import '../customwidgets/DeviderWidget.dart';
import 'package:shoplist_project/models/Call.dart';
import 'package:flutter/services.dart';
import 'call_view.dart';
import 'package:shoplist_project/signaling.dart';

//widget obrazovky participantov daneho nakupneho zoznamu
class ParticipantsView extends StatefulWidget {
  final AuthUser user;
  final List<Participant> participants;
  final String invite_code;
  final Call call;

  ParticipantsView(
      {required this.user,
      required this.participants,
      required this.invite_code,
      required this.call});

  @override
  State<ParticipantsView> createState() => _ParticipantsViewState();
}

class _ParticipantsViewState extends State<ParticipantsView> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer =
      RTCVideoRenderer(); // widget vlastneho obrazu z kamery
  RTCVideoRenderer _remoteRenderer =
      RTCVideoRenderer(); // widget obrazu z kamery druheho ucastnika hovoru

  @override
  void initState() {
    //inicializujeme local aj remote stream
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    //ked nastane novy stream od remote tak ho ulozi do remote renderer
    //a setstate aby sme videli to video
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  void callUser(
    int calledUserID,
    String calledUserEmail,
    String calledUserName,
  ) async {
    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
    try {
      var room_id = await widget.call.call_room_check(calledUserID);
      if (room_id == null) {
        room_id = await signaling.createRoom(_remoteRenderer);
      } else {
        signaling.joinRoom(room_id, _remoteRenderer);
      }
      widget.call.postCall(room_id, calledUserEmail);
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.call
            .showErrorDialog("An Error Occurred!", "No connection", context);
        return;
      } else if (e.toString() == "Exception: The user is already in a call") {
        widget.call.showErrorDialog("User is in a call",
            "The user is calling with someone else", context);
        return;
      }
    }
    gotoCallView(context, calledUserName);
  }

  //funkcia na navigaciu na obrazovku hovoru
  void gotoCallView(BuildContext ctx, String callWith) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (ctx) => CallView(
          callWith: callWith,
          localRenderer: _localRenderer,
          remoteRenderer: _remoteRenderer,
          signaling: signaling,
          call: widget.call,
        ),
      ),
    );
  }

  //widget konretneho participanta zoznamu - karticka z jeho infom
  Widget getParticipantWidget(int id, String name, String email, bool me) {
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
                      onPressed: () => callUser(id, email, name),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  //funckia na zostavenie a vratelie listu widgetov participantov
  List<Widget> getParticpantsListUI() {
    Widget owner = SizedBox();
    List<Widget> participList = widget.participants.map((participant) {
      if (participant.id == widget.user.id) {
        owner = getParticipantWidget(
          participant.id,
          "${participant.name} (You)",
          participant.email,
          true,
        );
        return SizedBox();
      } else {
        return getParticipantWidget(
          participant.id,
          participant.name,
          participant.email,
          false,
        );
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

  //build funckia obrazovky
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
              Text(widget.invite_code),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.invite_code));
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
