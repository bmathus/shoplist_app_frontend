import 'package:shoplist_project/models/ShopLists.dart';
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
  ShopList list;
  String token;

  Product({
    required this.picture_base64,
    required this.quantity,
    required this.unit,
    required this.bought,
    required this.id,
    required this.name,
    required this.list,
    required this.token,
  });

  Future<void> addProduct(ShopList lst) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/list/${lst.id}/product'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "name": name,
          "quantity": quantity,
          "unit": unit,
          "bought": bought,
          "picture_base64": picture_base64,
        }),
      );
      if (response.statusCode == 200) {
        var bodyMap = jsonDecode(response.body);
        id = bodyMap["id"];
        picture_base64 = bodyMap["picture_base64"];
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  Future<void> editProduct(ShopList lst, ShopLists lists, context) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/list/${lst.id}/product/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "name": name,
          "quantity": quantity,
          "unit": unit,
          "bought": bought,
          "picture_base64": picture_base64,
        }),
      );
      if (response.statusCode == 200) {
        // OK
      } else if (response.statusCode == 404) {
        // Potrebujeme odchytiť
        lists.showErrorDialog(
            "The product no longer exists. It might have been deleted by another user",
            context);
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }
}
