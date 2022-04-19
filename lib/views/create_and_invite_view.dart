import 'package:flutter/material.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'package:shoplist_project/models/UserAuth.dart';
import '../customwidgets/TextFieldWidget.dart';
import 'list_products_view.dart';

class CreateAndInviteView extends StatefulWidget {
  final bool create;
  final ShopLists lists;
  final AuthUser user;

  CreateAndInviteView(
      {required this.create, required this.lists, required this.user});
  @override
  State<CreateAndInviteView> createState() => _CreateAndInviteViewState();
}

class _CreateAndInviteViewState extends State<CreateAndInviteView> {
  TextEditingController controller = TextEditingController();
  String? errorText = null;
  bool loading = false;

  void gotoListProductsView(BuildContext ctx, ShopList shoplist) {
    Navigator.of(ctx)
        .push(
          MaterialPageRoute(
            builder: (ctx) => ListProductsView(
              user: widget.user,
              shoplist: shoplist,
              lists: widget.lists,
            ),
          ),
        )
        .then((value) => Navigator.of(context).pop());
  }

  void createShopList() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      loading = true;
    });
    if (controller.text.isEmpty) {
      setState(() {
        loading = false;
        errorText = "Name is required";
      });
      return;
    }
    if (controller.text.length > 50) {
      setState(() {
        loading = false;
        errorText = "Name can be max. 50 characters long";
      });
      return;
    }
    setState(() {
      errorText = null;
    });
    try {
      ShopList? shoplist = await widget.lists.postNewList(controller.text);
      setState(() {
        loading = false;
      });
      gotoListProductsView(context, shoplist!);
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.lists.showErrorDialog("No connection", context);
        setState(() {
          loading = false;
        });
      }
    }
  }

  void addUserToList() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      loading = true;
    });
    if (controller.text.isEmpty) {
      setState(() {
        loading = false;
        errorText = "Invite-code is required";
      });
      return;
    }
    setState(() {
      errorText = null;
    });
    try {
      ShopList? shoplist = await widget.lists.joinList(controller.text);
      setState(() {
        loading = false;
      });
      gotoListProductsView(context, shoplist!);
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.lists.showErrorDialog("No connection", context);
      } else if (e.toString() == "Exception: List does not exist") {
        setState(() {
          errorText = "List does not exist";
        });
      } else if (e.toString() == "Exception: You are already in this list") {
        setState(() {
          errorText = "You are already in this list";
        });
      } else if (e.toString() == "Exception: Invalid code") {
        setState(() {
          errorText = "Invalid code";
        });
      }
      setState(() {
        loading = false;
      });
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
            errorText: errorText,
            controller: controller,
            title: widget.create
                ? "Enter shopping list name"
                : "Enter invite code",
            hintText: widget.create ? "shopping list name" : "invite code",
            top: 10,
            left: 10,
            right: 10,
          ),
          loading
              ? Padding(
                  padding: EdgeInsets.only(left: 11, right: 11),
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    color: Color(0xFF355C7D),
                  ),
                )
              : SizedBox(),
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
          ),
        ],
      ),
    );
  }
}
