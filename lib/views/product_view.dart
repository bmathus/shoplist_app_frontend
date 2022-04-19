import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/Product.dart';
import 'package:shoplist_project/customwidgets/TextFieldWidget.dart';
import 'package:shoplist_project/customwidgets/ButtonWidget.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'package:image_picker/image_picker.dart';

//widget obrazovky detailu produktu
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
  //kontrolery za zadane inputy pri vytvarani/editovani produktu
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  //premmene na errorove hlasky textfieldov
  String? nameError;
  String? unitError;
  String? quantityError;
  bool loading = false;
  Uint8List? image; //obrazok produktu

  //funckia na odstranenie trailing 0
  String remove0(double n) {
    return n.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
  }

  //pri prvom builde widgetu v pripade editovania produktu
  //nacitanie textfieldov udajmy
  @override
  void initState() {
    image = widget.product?.picture_base64 != null
        ? base64Decode(widget.product!.picture_base64!)
        : null;

    if (widget.edit) {
      nameController.text = widget.product!.name;
      quantityController.text = widget.product!.quantity == null
          ? ""
          : remove0(widget.product!.quantity!);
      unitController.text = (widget.product!.unit ?? "");
    }

    super.initState();
  }

  //funkcia na vyber obrazka z galerie
  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return; //ak user nevyberie image z galerie
      final imageTemporary = File(image.path).readAsBytesSync();

      //updatneme ui aby sa image zobrazil
      setState(() {
        this.image = imageTemporary;
      });
    } catch (e) {
      print(e);
    }
  }

  //funkcia validovania vstupov z textfieldov
  bool validators() {
    bool error = false;
    String name = nameController.text;
    String qty = quantityController.text;
    String unit = unitController.text;

    if (qty.contains(',')) {
      quantityController.text = qty.replaceFirst(RegExp(','), '.');
      qty = quantityController.text;
    }
    setState(() {
      loading = true;
      nameError = null;
      unitError = null;
      quantityError = null;
    });

    if (name.isEmpty) {
      nameError = "Name is required";
      error = true;
    }
    if (name.length > 20) {
      nameError = "Name can be max. 20 characters long";
      error = true;
    }
    if (qty.length > 10) {
      quantityError = "Max. 10 char. long number";
      error = true;
    }
    if (unit.length > 10) {
      unitError = "Max. 10 characters";
      error = true;
    }

    return error;
  }

  //funkcia na spracovanie volani pridavania a editovania produktov
  //updatovanie UI vzhladom na odpovede volani pomocou zachytenych exceptions
  void add_edit_Product() async {
    if (validators()) {
      setState(() {
        loading = false;
      });
    } else {
      try {
        if (widget.edit) {
          await widget.product!.editProduct(
            list: widget.shoplist,
            name: nameController.text,
            quantity: quantityController.text == ""
                ? null
                : double.parse(quantityController.text),
            unit: unitController.text == "" ? null : unitController.text,
            picture_base64: image == null ? null : base64Encode(image!),
          );
        } else {
          await widget.shoplist.addProduct(
            name: nameController.text,
            quantity: quantityController.text == ""
                ? null
                : double.parse(quantityController.text),
            unit: unitController.text == "" ? null : unitController.text,
            picture_base64: image == null ? null : base64Encode(image!),
          );
        }
        setState(() {
          loading = false;
        });
      } on Exception catch (e) {
        setState(() {
          loading = false;
        });
        if (e.toString() == "Exception: No connection") {
          widget.shoplist.showErrorDialog("No connection", context);
          return;
        } else if (e.toString() == "Exception: Not found") {
          await widget.product!
              .showErrorDialog("This product is deleted", context);
        }
      }

      Navigator.of(context).pop();
    }
  }

  //build funkcia obrazovky
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
                          0.40,
                      child: image != null
                          ? Image.memory(
                              image!,
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
                        onPressed: () {
                          pickImage();
                        },
                        child: const Icon(
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
                  errorText: nameError,
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
                        errorText: quantityError,
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
                        errorText: unitError,
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
                const Spacer(),
                loading
                    ? const CircularProgressIndicator(
                        color: Color(0xFF355C7D),
                      )
                    : ButtonWidget(widget.edit ? "Save" : "Add product",
                        () => add_edit_Product()),
                const SizedBox(
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
