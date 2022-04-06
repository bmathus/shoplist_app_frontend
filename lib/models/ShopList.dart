import 'package:flutter/material.dart';

class ShopList {
  final int id;
  final String name;
  final int num_ppl;
  final int num_items;
  final String invite_code;
  final Color color; //bude backround color kategorie

  const ShopList(
      {required this.id,
      required this.name,
      required this.color,
      required this.num_ppl,
      required this.num_items,
      required this.invite_code});
}
