import 'package:flutter/material.dart';
import './customwidgets/UserInfoWidget.dart';
import './customwidgets/ShopListWidget.dart';
import './models/dummyLists.dart';
import './customwidgets/DeviderWidget.dart';
import 'create_list_view.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  AppBar appBar = AppBar(
    title: Text('Home'),
    centerTitle: true,
  );

  void gotoCreateAndInviteView(BuildContext ctx, bool create) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => CreateAndInviteView(create),
      ),
    );
  }

  List<Widget> getHomeUI() {
    List<Widget> widgets = [UserInfoWidget()];
    bool shared = false;
    var numoflists = dLists.length;
    if (dLists.isNotEmpty) {
      if (dLists[0].numofppl == 1) {
        widgets.add(const DeviderWidget("Private lists"));
      }
      for (var i = 0; i < numoflists; i++) {
        if (dLists[i].numofppl != 1 && shared == false) {
          shared = true;
          widgets.add(DeviderWidget("SharedLists"));
        }
        widgets.add(ShopListWidget(shoplist: dLists[i]));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top -
                    105,
                child: ListView(children: getHomeUI()),
              ),
              SizedBox(
                height: 45,
                width: mediaQuery.size.width - 20,
                child: ElevatedButton(
                  onPressed: () => gotoCreateAndInviteView(context, true),
                  child: Text("Create new shopping list"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF355C7D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 45,
                width: mediaQuery.size.width - 20,
                child: ElevatedButton(
                  onPressed: () => gotoCreateAndInviteView(context, false),
                  child: Text("Join shopping list"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF355C7D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
