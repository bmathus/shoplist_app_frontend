import 'package:shoplist_project/models/ShopLists.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Product {
  int id;
  String name;
  double? quantity;
  String? unit;
  bool bought;
  String? picture_base64;
  String token;

  Product({
    required this.picture_base64,
    required this.quantity,
    required this.unit,
    required this.bought,
    required this.id,
    required this.name,
    required this.token,
  });

  Future<void> editProduct({
    required ShopList list,
    required String name,
    required double? quantity,
    required String? unit,
    required String? picture_base64,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/list/${list.id}/product/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "name": name,
          "quantity": quantity,
          "unit": unit,
          "bought": this.bought,
          "picture_base64": picture_base64,
        }),
      );
      if (response.statusCode == 200) {
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
        this.picture_base64 = picture_base64;
      } else if (response.statusCode == 404) {
        list.products.remove(this);
        list.num_items--;
        throw Exception("Not found");
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  Future<void> editBoughtProduct(ShopList list, bool changedBought) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/list/${list.id}/product/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "name": name,
          "quantity": quantity,
          "unit": unit,
          "bought": changedBought,
          "picture_base64": picture_base64,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 404) {
        list.products.remove(this);
        list.num_items--;
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  Future<void> showErrorDialog(String message, BuildContext context) async {
    await showDialog(
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
