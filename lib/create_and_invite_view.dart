import 'package:flutter/material.dart';
import './home_view.dart';

class CreateAndInviteView extends StatelessWidget {
  final bool create;
  const CreateAndInviteView(this.create);

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
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 58, 58),
                border: Border.all(color: Colors.black26)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                create
                    ? Text("Enter shopping list name")
                    : Text("Enter invite code"),
                TextField(
                  style: TextStyle(fontSize: 14),
                  cursorColor: Color(0xFF355C7D),
                  decoration: InputDecoration(
                    icon: Icon(Icons.shopping_bag_outlined),
                    hintText: create ? "shopping list name" : "invite code",
                    hintStyle: TextStyle(fontSize: 14),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
