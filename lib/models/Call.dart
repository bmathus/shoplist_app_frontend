import 'package:flutter/material.dart';
import './global_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Call {
  String token;
  Call({required this.token});

  Future<String?> call_room_check(int calledUserId) async {
    try {
      final response = await http.get(
        Uri.parse('${host}call/$calledUserId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );
      var bodyMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return bodyMap['room_id'];
      } else if (response.statusCode == 400) {
        if (bodyMap['detail'] == "The user is already in a call") {
          throw Exception("The user is already in a call");
        }
      }
    } on SocketException {
      throw Exception("No connection");
    }
    return null;
  }

  Future<void> postCall(String? room_id, String called_email) async {
    try {
      final response = await http.post(Uri.parse('${host}call'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Token $token",
          },
          body: jsonEncode({
            "room_id": room_id,
            "called_user": called_email,
          }));
      if (response.statusCode == 200) {
        return;
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  Future<void> call_end() async {
    try {
      final response = await http.delete(
        Uri.parse('${host}call/end'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );
      if (response.statusCode == 200) {
        return;
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  ButtonStyle buttonstyle(Color color) => ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  void showErrorDialog(String header, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(header),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            style: buttonstyle(Color(0xFF355C7D)),
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
