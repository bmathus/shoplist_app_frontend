import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Product.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'package:shoplist_project/models/UserAuth.dart';
import 'package:shoplist_project/product_view.dart';
import 'package:shoplist_project/models/dummyLists.dart';

class ProductItemWidget extends StatefulWidget {
  final Product product;
  final ShopList shoplist;
  final ShopLists lists;
  final Function reBuild;
  final AuthUser user;

  ProductItemWidget(
      this.shoplist, this.product, this.reBuild, this.user, this.lists);

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  void gotoProductView(BuildContext ctx, bool edit) {
    Navigator.of(ctx)
        .push(
          MaterialPageRoute(
              builder: (ctx) => ProductView(widget.shoplist, edit,
                  widget.product, widget.user, widget.lists)),
        )
        .then((value) => setState(() {}));
  }

  String outputQuantity(var n) {
    if (n == null) {
      return "";
    } else {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }
  }

  void delWait() async {
    await widget.shoplist.delProduct(widget.product);
    widget.shoplist.products.remove(widget.product);
    widget.reBuild();
  }

  void editWait() async {
    await widget.product.editProduct(widget.shoplist, widget.lists, context);
    widget.reBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 43, 43, 43),
        border: Border(
          top: BorderSide(color: Color.fromARGB(66, 255, 255, 255), width: 1),
        ),
      ),
      child: ListTile(
        title: Text(widget.product.name),
        onTap: () => gotoProductView(context, true),
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        leading: Checkbox(
          activeColor: Color.fromARGB(255, 12, 162, 147),
          value: widget.product.bought,
          onChanged: (value) {
            widget.product.bought = value!;
            editWait();
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "${outputQuantity(widget.product.quantity)} ${widget.product.unit ?? ""}",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const VerticalDivider(
              indent: 5,
              endIndent: 5,
              color: Color.fromARGB(66, 255, 255, 255),
              thickness: 1,
              width: 0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: IconButton(
                icon: Icon(Icons.delete_rounded),
                onPressed: () {
                  delWait();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
