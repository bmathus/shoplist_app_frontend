import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Participant.dart';
import 'package:shoplist_project/models/Product.dart';
import 'package:http/http.dart' as http;
import './global_settings.dart';

//trieda reprezentujuca objekty s dantamy konkretnych nakupnuch zoznamov
class ShopList {
  //atributy zoznamu (rovnake ako v DB)
  final int id;
  final String name;
  int num_ppl;
  int num_items;
  final String invite_code;

  List<Participant> participants; //list vsetkych participantov zoznamu
  List<Product> products; //list vsetkych produktov zoznamu
  final String token; //token pouzivatela ktory ma tento zoznam nacitany na FE

  ShopList(
      {required this.id,
      required this.name,
      required this.num_ppl,
      required this.num_items,
      required this.invite_code,
      required this.participants,
      required this.products,
      required this.token});

  //funckia na volanie POST list/{id}/product na backend
  //teda na vytvorenie noveho produktu a ulozenie ho do DB
  Future<void> addProduct({
    required String name,
    required double? quantity,
    required String? unit,
    required String? picture_base64,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${host}list/${id}/product'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "name": name,
          "unit": unit,
          "quantity": quantity,
          "picture_base64": picture_base64,
        }),
      );
      if (response.statusCode == 200) {
        var bodyMap = jsonDecode(response.body);
        num_items++;
        products.add(Product(
            picture_base64: bodyMap["picture_base64"],
            quantity: bodyMap["quantity"],
            unit: bodyMap["unit"],
            bought: bodyMap["bought"],
            id: bodyMap["id"],
            name: bodyMap["name"],
            token: token));
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  //funckia na volanie GET list/{id} na backend
  //teda nacitanie vsetkych produktov zoznamu z DB
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${host}list/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );
      if (response.statusCode == 200) {
        List<Product> listProducts = [];
        var bodyMap = jsonDecode(response.body);
        bodyMap['products'].forEach((product) {
          listProducts.add(Product(
            id: product['id'],
            name: product['name'],
            quantity: product['quantity'],
            unit: product['unit'],
            bought: product['bought'],
            picture_base64: product['picture_base64'],
            token: token,
          ));
        });
        num_items = listProducts.length;
        products = listProducts;
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  //funkcia na volanie DELETE list/{id}/product{product_id} na backend
  //teda vymazanie konkretneho produktu zo zoznamu
  Future<void> deleteProduct(Product product) async {
    try {
      final response = await http.delete(
        Uri.parse('${host}list/$id/product/${product.id}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 404) {}
    } on SocketException {
      throw Exception("No connection");
    }
  }

  //funkcia na volanie GET list/{id}/participants na backend
  //teda nacitanie vsetkych participantov z BE
  Future<void> fetchParticipants() async {
    try {
      final response = await http.get(
        Uri.parse('${host}list/$id/participants'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );
      if (response.statusCode == 200) {
        List<Participant> listParticipants = [];
        var bodyMap = jsonDecode(response.body);
        bodyMap['users'].forEach((participant) {
          listParticipants.add(Participant(
            id: participant['id'],
            name: participant['name'],
            email: participant['email'],
          ));
        });
        num_ppl = listParticipants.length;
        participants = listParticipants;
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  //funkcia na zobrazenie error dialogu v pripade chyby pri volania na BE
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

//trieda na ukladanie vsetkych zoznamov prihlaseneho pouzivatela
class ShopLists {
  String token;
  List<ShopList> allLists = []; //list vsetkych zoznamov
  ShopLists({required this.token});

  //funkcia na volanie GET lists na backend
  //teda nacitanie vsetkych zoznamov prihlaseneho pouzivatela
  Future<void> fetchShopLists() async {
    try {
      final responce = await http.get(
        Uri.parse('${host}lists'),
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
              participants: [],
              products: [],
              token: token));
        });
        allLists = allFetchedLists;
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  //funkcia na volanie POST lists na backend
  //teda vytvorenie noveho zoznamu a ulozenie ho na DB
  Future<ShopList?> postNewList(String name) async {
    try {
      final responce = await http.post(
        Uri.parse('${host}lists'),
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
        ShopList shoplist = ShopList(
            id: bodyMap['id'],
            name: bodyMap['name'],
            num_ppl: bodyMap['num_ppl'],
            num_items: bodyMap['num_items'],
            invite_code: bodyMap['invite_code'],
            participants: [],
            products: [],
            token: token);

        allLists.add(shoplist);
        return shoplist;
      }
    } on SocketException {
      throw Exception("No connection");
    }
    return null;
  }

  //funkcia na volanie POST list/invite na backend
  //teda na joinutie zoznamu s danym invite kodom
  Future<ShopList?> joinList(String invite_code) async {
    try {
      final response = await http.post(
        Uri.parse('${host}list/invite'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "invite_code": invite_code,
        }),
      );
      if (response.statusCode == 200) {
        var bodyMap = jsonDecode(response.body);
        ShopList shoplist = ShopList(
            id: bodyMap["id"],
            name: bodyMap["name"],
            num_ppl: bodyMap["num_ppl"],
            num_items: bodyMap["num_items"],
            invite_code: bodyMap["invite_code"],
            participants: [],
            products: [],
            token: token);
        allLists.add(shoplist);
        return shoplist;
      } else if (response.statusCode == 404) {
        throw Exception("List does not exist");
      } else if (response.statusCode == 400) {
        var body = jsonDecode(response.body);
        if (body["detail"] == "You are already in this list.") {
          throw Exception("You are already in this list");
        } else {
          throw Exception("Invalid code");
        }
      }
    } on SocketException {
      throw Exception("No connection");
    }
  }

  //funkcia na volanie DELETE list/{list_id} na backend
  //teda na odstranenie alebo leavnutie zoznamu s danym id
  Future<void> leaveList(ShopList list) async {
    try {
      final response = await http.delete(
        Uri.parse('${host}list/${list.id}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );
      if (response.statusCode == 200) {
        allLists.remove(list);
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

  //funckia na zobrazenie error dialogu v pripade chyby pri volaniach
  void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text("Okay"),
            style: buttonstyle(Color(0xFF355C7D)),
            onPressed: () {
              Navigator.pop(context, 'Okay');
            },
          )
        ],
      ),
    );
  }
}
