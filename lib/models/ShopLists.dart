import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Participant.dart';
import 'package:shoplist_project/models/Product.dart';
import 'package:http/http.dart' as http;
import 'UserAuth.dart';

class ShopList {
  final int id;
  final String name;
  final int num_ppl;
  final int num_items;
  final String invite_code;
  List<Participant> users;
  List<Product> products;

  ShopList({
    required this.id,
    required this.name,
    required this.num_ppl,
    required this.num_items,
    required this.invite_code,
    required this.users,
    required this.products,
  });
}

class ShopLists {
  String token;
  List<ShopList> allLists = [];
  ShopLists({required this.token});

  Future<void> fetchShopLists() async {
    try {
      final responce = await http.get(
        Uri.parse('http://10.0.2.2:8000/lists'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );
      if (responce.statusCode == 200) {
        List<ShopList> allFetchedLists = [];
        var bodyMap = jsonDecode(responce.body);
        bodyMap['lists'].forEach((list) {
          allFetchedLists.add(ShopList(
            id: list['id'],
            name: list['name'],
            num_ppl: list['num_ppl'],
            num_items: list['num_items'],
            invite_code: list['invite_code'],
            users: [],
            products: [],
          ));
        });
        allLists = allFetchedLists;
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  Future<void> postNewList(String name) async {
    try {
      final responce = await http.post(
        Uri.parse('http://10.0.2.2:8000/lists'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "name": name,
        }),
      );
      if (responce.statusCode == 200) {
        var bodyMap = jsonDecode(responce.body);
        allLists.add(ShopList(
          id: bodyMap['id'],
          name: bodyMap['name'],
          num_ppl: bodyMap['num_ppl'],
          num_items: bodyMap['num_items'],
          invite_code: bodyMap['invite_code'],
          users: [],
          products: [],
        ));
      }
    } on SocketException {
      throw Exception("No connection");
    }
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
