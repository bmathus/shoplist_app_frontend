import 'package:flutter/material.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import './customwidgets/UserInfoWidget.dart';
import './customwidgets/ShopListWidget.dart';
import './customwidgets/DeviderWidget.dart';
import 'create_and_invite_view.dart';
import 'customwidgets/ButtonWidget.dart';
import 'models/UserAuth.dart';

class HomeView extends StatefulWidget {
  final AuthUser user;
  final ShopLists lists;

  HomeView({required this.user, required this.lists});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool listsLoading = false;

  void gotoCreateAndInviteView(BuildContext ctx, bool create) {
    Navigator.of(ctx)
        .push(
          MaterialPageRoute(
            builder: (ctx) => CreateAndInviteView(
              create: create,
              lists: widget.lists,
            ),
          ),
        )
        .then((value) => setState(() {}));
  }

  Future<void> refresh() async {
    try {
      await widget.lists.fetchShopLists();
      setState(() {});
    } catch (e) {}
  }

  void loadLists() async {
    setState(() {
      listsLoading = true;
    });
    try {
      await widget.lists.fetchShopLists();
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.user.showErrorDialog("No connection", context);
      } else {
        widget.user.showErrorDialog("Something went wrong", context);
      }
    }
    setState(() {
      listsLoading = false;
    });
  }

  @override
  void initState() {
    loadLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('builduje home view');
    final mediaQuery = MediaQuery.of(context);

    AppBar appBar = AppBar(
      title: const Text('Home'),
      centerTitle: true,
    );

    List privateLists = [];
    List sharedLists = [];

    List<Widget> getHomeUI() {
      widget.lists.allLists.forEach((list) {
        if (list.num_ppl == 1) {
          privateLists.add(ShopListWidget(
            shoplist: list,
            user: widget.user,
            lists: widget.lists,
            rebuildHomeView: () => setState(() {}),
          ));
        } else {
          sharedLists.add(ShopListWidget(
            shoplist: list,
            user: widget.user,
            lists: widget.lists,
            rebuildHomeView: () => setState(() {}),
          ));
        }
      });

      if (privateLists.isEmpty && sharedLists.isEmpty) {
        return [
          UserInfoWidget(user: widget.user),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Image.asset(
                "assets/list-is-empty.png",
                fit: BoxFit.cover,
                color: Color.fromARGB(83, 89, 89, 89),
              ),
              SizedBox(height: 10),
              Center(
                  child: Text(
                "No lists",
                style: TextStyle(
                  color: Color.fromARGB(111, 89, 89, 89),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ))
            ],
          )
        ];
      }

      return [
        UserInfoWidget(user: widget.user),
        privateLists.isNotEmpty
            ? const DeviderWidget("Private lists")
            : const SizedBox(),
        ...privateLists,
        sharedLists.isNotEmpty
            ? const DeviderWidget("Shared lists")
            : const SizedBox(),
        ...sharedLists,
      ];
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: listsLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      child: ListView(children: getHomeUI()),
                      onRefresh: refresh),
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
