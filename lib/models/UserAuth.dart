import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import './global_settings.dart';

import 'package:http/http.dart' as http;

//trieda reprezentujuca objekt prihlaseneho pouzivatela
class AuthUser {
  //atributy prihlaseneho pouzivatela
  late int id;
  late String name;
  late String email;
  late String token;

  //funckia na volanie POST auth-user na backend
  //teda volanie na prihlasenie pouzivatela s danymy prihlas. udajmy
  Future<void> login({required String email, required String password}) async {
    try {
      final responce = await http.post(
        Uri.parse('${host}auth-user'),
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

        //ulozenie prihlasovacich udajov do pamate applikacie pre pripad autologinu
        //teda v pripade ze po zavreti appky ostane user prihlaseny teda nemusi sa
        //znova prihlasovat pri zapnuti appky
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

  //funkcia na autologin teda nacitanie udajov prihlaseneho pouzivatela z pamate
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

  ButtonStyle buttonstyle(Color color) => ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  //funkcia na zobrazenie erroroveho dialogu v pripade chyby pri volaniach na BE
  void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
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
