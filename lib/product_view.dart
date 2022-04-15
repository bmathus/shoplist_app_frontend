import 'package:flutter/material.dart';
import 'package:shoplist_project/models/UserAuth.dart';
import './models/Product.dart';
import 'package:shoplist_project/customwidgets/TextFieldWidget.dart';
import 'package:shoplist_project/customwidgets/ButtonWidget.dart';
import 'package:shoplist_project/models/ShopLists.dart';

class ProductView extends StatefulWidget {
  final bool edit;
  final ShopList shoplist;
  final ShopLists lists;
  final Product? product;
  final AuthUser user;

  ProductView(
    this.shoplist,
    this.edit,
    this.product,
    this.user,
    this.lists,
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
      quantityController.text = widget.product!.quantity == null
          ? ""
          : widget.product!.quantity.toString();
      unitController.text = (widget.product!.unit ?? "");
    }

    super.initState();
  }

  void add_edit_Product() {
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
      if (widget.edit) {
        widget.product!.name = nameController.text;
        widget.product!.unit =
            unitController.text == "" ? null : unitController.text;
        widget.product!.quantity = quantityController.text == ""
            ? null
            : double.parse(quantityController.text);
        widget.product!.picture_base64 = "SomeFakeValuePlaceholder";
        widget.product!.editProduct(widget.shoplist, widget.lists, context);
      } else {
        Product newp = Product(
          id: 0,
          name: nameController.text,
          quantity: quantityController.text == ""
              ? null
              : double.parse(quantityController.text),
          unit: unitController.text == "" ? null : unitController.text,
          bought: false,
          picture_base64:
              "fdsagfa", // Pridať upload obrázku a base64-encoding nejako!
          list: widget.shoplist,
          token: widget.user.token,
        );
        newp.addProduct(widget.shoplist);
        widget.shoplist.num_items++;
        widget.shoplist.products.add(
          newp,
        );
      }

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
                Stack(
                  alignment: Alignment.bottomRight,
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
                                "Add product picture",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(122, 255, 255, 255),
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.photo_library_rounded,
                          size: 30,
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 8,
                            primary: Color(0xFF355C7D),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10)),
                      ),
                    ),
                  ],
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
                ButtonWidget(widget.edit ? "Save" : "Add product",
                    () => add_edit_Product()),
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
