import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Participant.dart';
import 'Product.dart';
import 'ShopLists.dart';
import 'UserAuth.dart';

List<Product> dProducts = [
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

List<Participant> dParticipants = [
  Participant(id: 1, name: "Matus", email: "bojko@email.com"),
  Participant(id: 2, name: "Jozef", email: "bojko@email.com"),
  Participant(id: 3, name: "Adam", email: "bojko@email.com"),
  Participant(id: 4, name: "Marek", email: "bojko@email.com"),
  Participant(id: 5, name: "Miro", email: "bojko@email.com"),
  Participant(id: 6, name: "Sebastian", email: "bojko@email.com"),
  Participant(id: 7, name: "Marian", email: "bojko@email.com"),
  Participant(id: 8, name: "Michal", email: "bojko@email.com")
];
List<Product> dProducts2 = [
  Product(
      picture_base64: "fsdahfdsji",
      quantity: 3989,
      unit: "pkg",
      bought: false,
      id: 3,
      name: "Exclusive"),
];

List<ShopList> dLists = [
  ShopList(
      id: 1,
      name: 'Matusov list',
      num_ppl: 1,
      num_items: 4,
      invite_code: "hufdhsuifds",
      products: dProducts,
      users: dParticipants),
  ShopList(
      id: 2,
      name: 'Adamov list',
      num_ppl: 1,
      num_items: 3,
      invite_code: "FHJIDOHJ",
      products: dProducts,
      users: dParticipants),
  ShopList(
      id: 3,
      name: 'Luckin list',
      num_ppl: 1,
      num_items: 99,
      invite_code: "uifhids",
      products: dProducts,
      users: dParticipants),
  ShopList(
      id: 4,
      name: 'Zdielany list 1',
      num_ppl: 2,
      num_items: 1,
      invite_code: "jifosdj",
      products: dProducts2,
      users: dParticipants),
  ShopList(
      id: 5,
      name: 'Zdielany list 2',
      num_ppl: 7,
      num_items: 4,
      invite_code: "jiofsdf",
      products: dProducts,
      users: dParticipants),
  ShopList(
      id: 5,
      name: 'Zdielany list 2',
      num_ppl: 7,
      num_items: 4,
      invite_code: "fbndujsifds",
      products: dProducts,
      users: dParticipants),
  ShopList(
      id: 5,
      name: 'Zdielany list 2',
      num_ppl: 7,
      num_items: 4,
      invite_code: "nifojdiosjo",
      products: dProducts,
      users: dParticipants),
];
