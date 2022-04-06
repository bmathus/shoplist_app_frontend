import 'package:flutter/material.dart';
import './customwidgets/UserInfoWidget.dart';
import './customwidgets/ShopListWidget.dart';
import './models/dummyLists.dart';
import './customwidgets/DeviderWidget.dart';
import 'create_and_invite_view.dart';
import 'customwidgets/ButtonWidget.dart';

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
      if (dLists[0].num_ppl == 1) {
        widgets.add(const DeviderWidget("Private lists"));
      }
      for (var i = 0; i < numoflists; i++) {
        if (dLists[i].num_ppl != 1 && shared == false) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(children: getHomeUI()),
            ),
            const SizedBox(
              height: 8,
            ),
            ButtonWidget("Create new shopping list",
                () => gotoCreateAndInviteView(context, true)),
            const SizedBox(
              height: 8,
            ),
            ButtonWidget("Join shopping list",
                () => gotoCreateAndInviteView(context, false)),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
