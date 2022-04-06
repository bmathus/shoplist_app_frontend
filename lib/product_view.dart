import 'package:flutter/material.dart';
import './models/Product.dart';

class ProductView extends StatelessWidget {
  final bool edit;
  final Product? product;

  const ProductView(
    this.edit,
    this.product,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: edit ? Text("Edit product") : Text("Add product"),
      ),
      body: Center(
        child: Text("Product scafold"),
      ),
    );
  }
}
