import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthUser {
  late int id;
  late String name;
  late String email;
  late String token;

  Future<void> login({required String email, required String password}) async {
    try {
      final responce = await http.post(
        Uri.parse('http://10.0.2.2:8000/auth-user'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": email,
          "password": password,
        }),
      );
      if (responce.statusCode == 200) {
        var body_map = jsonDecode(responce.body);
        this.id = body_map["id"];
        this.name = body_map["name"];
        this.email = body_map["email"];
        this.token = body_map["token"];

        final prefs = await SharedPreferences.getInstance();

        final userData = json.encode({
          'id': this.id,
          'name': this.name,
          'email': this.email,
          'token': this.token,
        });

        prefs.setString("userData", userData);
      } else if (responce.statusCode == 401) {
        throw Exception("Unauthorized");
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }

    final storedUserData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    id = storedUserData['id'];
    name = storedUserData['name'];
    email = storedUserData['email'];
    token = storedUserData['token'];
    return true;
  }

  void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
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
