import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Product.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'package:shoplist_project/product_view.dart';

class ProductItemWidget extends StatefulWidget {
  final Product product;
  final ShopList shoplist;
  final Function reBuildListProductView;

  ProductItemWidget(this.shoplist, this.product, this.reBuildListProductView);

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  void gotoProductView(BuildContext ctx, bool edit) {
    Navigator.of(ctx)
        .push(
          MaterialPageRoute(
              builder: (ctx) => ProductView(
                    widget.shoplist,
                    edit,
                    widget.product,
                  )),
        )
        .then((value) => widget.reBuildListProductView());
  }

  String checkNull(var n) {
    if (n == null) {
      return "";
    } else {
      return n.toString();
    }
  }

  void deleteProduct() async {
    Product tempProduct = widget.product;
    try {
      widget.shoplist.products.remove(widget.product);
      widget.shoplist.num_items--;
      widget.reBuildListProductView();
      await widget.shoplist.deleteProduct(widget.product);
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.shoplist.showErrorDialog("No connection", context);
        widget.shoplist.products.add(tempProduct);
        widget.shoplist.num_items++;
        widget.reBuildListProductView();
      }
    }
  }

  void boughtEditProduct(bool changedBought) async {
    bool tempBought = widget.product.bought;
    try {
      widget.product.bought = changedBought;
      widget.reBuildListProductView();
      await widget.product.editBoughtProduct(widget.shoplist, changedBought);
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.shoplist.showErrorDialog("No connection", context);
        widget.product.bought = tempBought;
      }
    }
    widget.reBuildListProductView();
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
            onChanged: (value) => boughtEditProduct(value!)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "${checkNull(widget.product.quantity)} ${widget.product.unit ?? ""}",
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
                onPressed: () => deleteProduct(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
