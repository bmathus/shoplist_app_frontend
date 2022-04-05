import 'package:flutter/material.dart';

class ShopList {
  final int id;
  final String listName;
  final Color color; //bude backround color kategorie
  final int numofppl;
  final int numofprod;

  const ShopList(
      {required this.id,
      required this.listName,
      required this.color,
      required this.numofppl,
      required this.numofprod});
}
