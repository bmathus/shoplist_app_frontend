import 'package:flutter/material.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'package:shoplist_project/list_products_view.dart';
import 'package:shoplist_project/models/UserAuth.dart';

class ShopListWidget extends StatelessWidget {
  final ShopLists lists;
  final ShopList shoplist;
  final AuthUser user;
  final Function rebuildHomeView;

  ShopListWidget(
      {required this.shoplist,
      required this.user,
      required this.lists,
      required this.rebuildHomeView});

  void gotoListProductsView(BuildContext ctx) {
    Navigator.of(ctx)
        .push(
      MaterialPageRoute(
        builder: (ctx) => ListProductsView(
          user: user,
          shoplist: shoplist,
          lists: lists,
        ),
      ),
    )
        .then((value) {
      rebuildHomeView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
        height: 75,
        child: ListTile(
          onTap: () => gotoListProductsView(context),
          title: Text(shoplist.name),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${shoplist.num_items} products"),
                shoplist.num_ppl == 1
                    ? const Text("Only you")
                    : Text("${shoplist.num_ppl} participants"),
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 41, 94, 84).withOpacity(0.8),
            Color.fromARGB(255, 54, 54, 54)
          ], begin: Alignment.topLeft, end: Alignment.topRight),
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
