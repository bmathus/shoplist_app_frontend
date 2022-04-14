import 'package:flutter/material.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import './home_view.dart';
import 'customwidgets/TextFieldWidget.dart';

class CreateAndInviteView extends StatefulWidget {
  final bool create;
  final ShopLists lists;

  CreateAndInviteView({
    required this.create,
    required this.lists,
  });
  @override
  State<CreateAndInviteView> createState() => _CreateAndInviteViewState();
}

class _CreateAndInviteViewState extends State<CreateAndInviteView> {
  TextEditingController controller = TextEditingController();
  bool nameorcodeError = false;
  String inviteCodeErrorText = "";

  void createShopList() async {
    if (controller.text.isEmpty) {
      setState(() {
        nameorcodeError = true;
      });
      return;
    }
    setState(() {
      nameorcodeError = false;
    });
    try {
      await widget.lists.postNewList(controller.text);
      Navigator.of(context).pop();
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.lists.showErrorDialog("No connection", context);
      }
    }
  }

  void addUserToList() async {
    if (controller.text.isEmpty) {
      setState(() {
        nameorcodeError = true;
      });
      return;
    }
    setState(() {
      nameorcodeError = false;
      inviteCodeErrorText = "";
    });
    try {
      await widget.lists.joinList(controller.text);
      Navigator.of(context).pop();
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.lists.showErrorDialog("No connection", context);
      } else if (e.toString() == "Exception: List does not exist") {
        setState(() {
          inviteCodeErrorText = "List does not exist";
        });
      } else if (e.toString() == "Exception: You are already in this list") {
        setState(() {
          inviteCodeErrorText = "You are already in this list";
        });
      } else if (e.toString() == "Exception: Invalid code") {
        setState(() {
          inviteCodeErrorText = "Invalid code";
        });
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
            errorText: nameorcodeError
                ? (widget.create
                    ? "Name is required"
                    : "Invite-code is required")
                : inviteCodeErrorText.isNotEmpty
                    ? inviteCodeErrorText
                    : null,
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
            onPressed:
                widget.create ? () => createShopList() : () => addUserToList(),
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
