import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shoplist_project/signaling.dart';
import 'package:shoplist_project/models/Call.dart';

class CallView extends StatefulWidget {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final Signaling signaling;
  final String callWith;
  final Call call;
  const CallView(
      {required this.callWith,
      required this.localRenderer,
      required this.remoteRenderer,
      required this.signaling,
      required this.call});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text("Call with ${widget.callWith}"),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            child: RTCVideoView(widget.remoteRenderer),
            height: mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: RTCVideoView(widget.localRenderer, mirror: true),
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.25,
            width: mediaQuery.size.width * 0.25,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await widget.signaling.hangUp(widget.localRenderer);
            Navigator.of(context).pop();
            widget.call.call_end();
          } catch (e) {}
        },
        backgroundColor: Color.fromARGB(255, 104, 59, 64),
        child: Icon(
          Icons.call_end_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
