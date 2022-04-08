import 'package:flutter/material.dart';
import './home_view.dart';
import 'customwidgets/TextFieldWidget.dart';

class CreateAndInviteView extends StatelessWidget {
  final bool create;
  TextEditingController controller = TextEditingController();

  CreateAndInviteView(this.create);

  void gotoHomeView(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => HomeView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            create ? Text("Create shopping list") : Text("Join shopping list"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => gotoHomeView(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFieldWidget(
            errorText: "Treba dokodit",
            controller: controller,
            title: create ? "Enter shopping list name" : "Enter invite code",
            hintText: create ? "shopping list name" : "invite code",
            top: 10,
            left: 10,
            bottom: 10,
            right: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            child: create ? Text("Create") : Text("Join"),
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
