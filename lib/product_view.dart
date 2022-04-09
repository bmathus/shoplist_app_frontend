import 'package:flutter/material.dart';
import './models/Product.dart';
import 'package:shoplist_project/customwidgets/TextFieldWidget.dart';
import 'package:shoplist_project/customwidgets/ButtonWidget.dart';
import 'package:shoplist_project/models/ShopList.dart';

class ProductView extends StatefulWidget {
  final bool edit;
  final ShopList shoplist;
  final Product? product;

  ProductView(
    this.shoplist,
    this.edit,
    this.product,
  );

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  TextEditingController nameController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  TextEditingController unitController = TextEditingController();

  bool validateName = false;

  @override
  void initState() {
    if (widget.edit) {
      nameController.text = widget.product!.name;
      quantityController.text = widget.product!.quantity.toString();
      unitController.text = widget.product!.unit!;
    }

    super.initState();
  }

  void addProduct() {
    if (nameController.text.isEmpty) {
      setState(() {
        validateName = true;
      });
    } else {
      validateName = false;
      if (quantityController.text.contains(',')) {
        quantityController.text =
            quantityController.text.replaceFirst(RegExp(','), '.');
      }

      print(quantityController.text);
      widget.shoplist.products.add(
        Product(
          picture_base64: "fdsagfa",
          quantity: quantityController.text == ""
              ? null
              : double.parse(quantityController.text),
          unit: unitController.text == "" ? null : unitController.text,
          bought: false,
          id: 0,
          name: nameController.text,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final AppBar appBar = AppBar(
      title: widget.edit ? Text("Edit product") : Text("Add product"),
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 59, 58, 58),
                    border: Border.all(color: Colors.black26),
                  ),
                  width: double.infinity,
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.45,
                  child: widget.edit
                      ? Image.asset(
                          "assets/fruit.jpg",
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            "Product picture",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 0, 158, 142),
                            ),
                          ),
                        ),
                ),
                TextFieldWidget(
                  errorText: validateName ? "Name is required" : null,
                  controller: nameController,
                  title: "Product name",
                  hintText: "Enter name",
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        keyboardType: TextInputType.number,
                        controller: quantityController,
                        title: "Quantity",
                        hintText: "enter quantity",
                        left: 10,
                        top: 10,
                        right: 5,
                      ),
                    ),
                    Expanded(
                      child: TextFieldWidget(
                        controller: unitController,
                        title: "Unit",
                        hintText: "enter unit",
                        top: 10,
                        left: 5,
                        right: 10,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ButtonWidget(
                    widget.edit ? "Save" : "Add product", () => addProduct()),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
