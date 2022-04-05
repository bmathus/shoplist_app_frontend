import 'package:flutter/material.dart';
import './customwidgets/UserInfoWidget.dart';
import './customwidgets/ShopListWidget.dart';
import './models/dummyLists.dart';
import './customwidgets/DeviderWidget.dart';
import './customwidgets/ButtonWidget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoWidget(),
          DeviderWidget("Private lists"),
          ShopListWidget(
            id: 0,
            numofppl: 0,
            listName: "Matusov list",
            color: Colors.blue,
            numofprod: 4,
          ),
          ShopListWidget(
            id: 0,
            numofppl: 0,
            listName: "Matusov list 2",
            color: Colors.teal,
            numofprod: 4,
          ),
          DeviderWidget("Shared lists"),
          ShopListWidget(
            id: 1,
            numofppl: 7,
            listName: "Zdielany list",
            color: Colors.indigo,
            numofprod: 4,
          ),
          ShopListWidget(
            id: 1,
            numofppl: 7,
            listName: "Zdielany list 2",
            color: Colors.deepOrange,
            numofprod: 4,
          ),
        ],
      ),
    );
  }
}
