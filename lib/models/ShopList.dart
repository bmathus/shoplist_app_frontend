import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Product.dart';

class ShopList {
  final int id;
  final String name;
  final int num_ppl;
  final int num_items;
  final String invite_code;
  final Color color; //bude backround color kategorie
  List<User> users;
  List<Product> products;

  ShopList({
    required this.id,
    required this.name,
    required this.color,
    required this.num_ppl,
    required this.num_items,
    required this.invite_code,
    required this.users,
    required this.products,
  });
}

class User {
  int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});
}
