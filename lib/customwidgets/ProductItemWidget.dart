import 'package:flutter/material.dart';
import 'package:shoplist_project/models/Product.dart';
import 'package:shoplist_project/product_view.dart';
import 'package:shoplist_project/models/dummyLists.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;
  final String listName;
  final Function reBuild;

  ProductItemWidget(this.listName, this.product, this.reBuild);

  void gotoProductView(BuildContext ctx, bool edit) {
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (ctx) => ProductView(listName, edit, product)),
    );
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
        title: Text(product.name),
        onTap: () => gotoProductView(context, true),
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        leading: Checkbox(
          activeColor: Color.fromARGB(255, 12, 162, 147),
          value: product.bought,
          onChanged: (value) {
            product.bought = value;
            reBuild();
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "${product.quantity} ${product.unit}",
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
                  dProducts.remove(product);
                  reBuild();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
