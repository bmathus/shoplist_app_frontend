import 'package:flutter/material.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import './home_view.dart';
import 'customwidgets/TextFieldWidget.dart';

class CreateAndInviteView extends StatefulWidget {
  final bool create;
  final ShopLists lists;
  final Function rebuildHomeView;

  CreateAndInviteView(
      {required this.create,
      required this.lists,
      required this.rebuildHomeView});
  @override
  State<CreateAndInviteView> createState() => _CreateAndInviteViewState();
}

class _CreateAndInviteViewState extends State<CreateAndInviteView> {
  TextEditingController controller = TextEditingController();
  bool nameError = false;

  void createShopList() async {
    if (controller.text.isEmpty) {
      setState(() {
        nameError = true;
      });
      return;
    }
    setState(() {
      nameError = false;
    });
    try {
      await widget.lists.postNewList(controller.text);
      Navigator.of(context).pop();
      widget.rebuildHomeView();
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.lists.showErrorDialog("No connection", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.create
            ? Text("Create shopping list")
            : Text("Join shopping list"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFieldWidget(
            errorText:
                widget.create ? (nameError ? "Name is required" : null) : null,
            controller: controller,
            title: widget.create
                ? "Enter shopping list name"
                : "Enter invite code",
            hintText: widget.create ? "shopping list name" : "invite code",
            top: 10,
            left: 10,
            bottom: 10,
            right: 10,
          ),
          ElevatedButton(
            onPressed: widget.create ? () => createShopList() : () {},
            child: widget.create ? Text("Create") : Text("Join"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF355C7D)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
