import 'package:flutter/material.dart';
import 'Product.dart';
import 'ShopList.dart';

List dProducts = [
  Product(
      picture_base64: "njifnsdji",
      quantity: 45.9,
      unit: "L",
      bought: false,
      id: 1,
      name: "Mlieko"),
  Product(
      picture_base64: "njifgfdsji",
      quantity: 6,
      unit: "ks",
      bought: true,
      id: 2,
      name: "Banany"),
  Product(
      picture_base64: "fsdahfdsji",
      quantity: 3989,
      unit: "pkg",
      bought: false,
      id: 3,
      name: "Oriesky"),
  Product(
      picture_base64: "njijkghfhrsji",
      quantity: 84,
      unit: "ml",
      bought: true,
      id: 4,
      name: "Keksiky"),
  Product(
      picture_base64: "njifgdashgdfdji",
      quantity: 45.933,
      unit: "kg",
      bought: false,
      id: 5,
      name: "Halusky"),
  Product(
      picture_base64: "njifnsdji",
      quantity: 45.9,
      unit: "L",
      bought: false,
      id: 1,
      name: "Mlieko"),
  Product(
      picture_base64: "njifgfdsji",
      quantity: 6,
      unit: "ks",
      bought: true,
      id: 2,
      name: "Banany"),
  Product(
      picture_base64: "fsdahfdsji",
      quantity: 3989,
      unit: "pkg",
      bought: false,
      id: 3,
      name: "Oriesky"),
];

List dParticipants = [];

List dLists = const [
  ShopList(
      id: 1,
      name: 'Matusov list',
      num_ppl: 1,
      num_items: 4,
      color: Colors.lightBlue,
      invite_code: "hufdhsuifds"),
  ShopList(
    id: 2,
    name: 'Adamov list',
    num_ppl: 1,
    num_items: 3,
    color: Colors.teal,
    invite_code: "FHJIDOHJ",
  ),
  ShopList(
      id: 3,
      name: 'Luckin list',
      num_ppl: 1,
      num_items: 99,
      color: Colors.deepOrange,
      invite_code: "uifhids"),
  ShopList(
      id: 4,
      name: 'Zdielany list 1',
      num_ppl: 2,
      num_items: 1,
      color: Colors.indigo,
      invite_code: "jifosdj"),
  ShopList(
      id: 5,
      name: 'Zdielany list 2',
      num_ppl: 7,
      num_items: 4,
      color: Colors.brown,
      invite_code: "jiofsdf"),
  ShopList(
      id: 5,
      name: 'Zdielany list 2',
      num_ppl: 7,
      num_items: 4,
      color: Colors.brown,
      invite_code: "fbndujsifds"),
  ShopList(
      id: 5,
      name: 'Zdielany list 2',
      num_ppl: 7,
      num_items: 4,
      color: Colors.brown,
      invite_code: "nifojdiosjo"),
];
