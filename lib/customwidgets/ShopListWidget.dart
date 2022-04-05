import 'package:flutter/material.dart';
import 'package:shoplist_project/models/ShopList.dart';

class ShopListWidget extends StatelessWidget {
  final ShopList shoplist;

  ShopListWidget({
    required this.shoplist,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
        height: 90,
        child: ListTile(
          onTap: (() {}),
          title: Text(shoplist.listName),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${shoplist.numofprod} products"),
                shoplist.numofppl == 1
                    ? const Text("Only you")
                    : Text("${shoplist.numofppl} participants"),
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [shoplist.color.withOpacity(0.55), shoplist.color],
              begin: Alignment.topLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black38,
              offset: Offset(0, 2),
            )
          ],
        ),
      ),
    );
  }
}
