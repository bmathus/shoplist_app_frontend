import 'package:flutter/material.dart';

class ShopListWidget extends StatelessWidget {
  final int id;
  final int numofppl;
  final int numofprod;
  final String listName;
  final Color color;

  ShopListWidget({
    required this.id,
    required this.listName,
    required this.numofprod,
    required this.numofppl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
        height: 90,
        child: ListTile(
          onTap: (() {}),
          title: Text(listName),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("$numofprod products"),
                numofppl == 0
                    ? const Text("Only you")
                    : Text("$numofppl participants"),
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color.withOpacity(0.55), color],
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
