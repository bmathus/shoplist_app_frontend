import 'package:flutter/material.dart';
import 'package:shoplist_project/customwidgets/DeviderWidget.dart';
import 'package:shoplist_project/models/dummyLists.dart';
import './home_view.dart';
import 'package:shoplist_project/customwidgets/ProductItemWidget.dart';
import 'customwidgets/ButtonWidget.dart';
import 'package:shoplist_project/product_view.dart';
import './participants_view.dart';

class ListProductsView extends StatefulWidget {
  final String listName;
  const ListProductsView({required this.listName});

  @override
  State<ListProductsView> createState() => _ListProductsViewState();
}

class _ListProductsViewState extends State<ListProductsView> {
  int selectedIndexNavBar = 0;

  void gotoHomeView(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => HomeView(),
      ),
    );
  }

  void gotoProductView(BuildContext ctx, bool edit) {
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (ctx) => ProductView(edit, null)),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndexNavBar = index;
    });
  }

  void reBuild() => setState(() => {});

  Future<void> refresh() {
    return Future.delayed(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    AppBar appBar = AppBar(
      title: Text(widget.listName),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.home_rounded, size: 30),
        onPressed: () => gotoHomeView(context),
      ),
    );

    Widget deleteButton = Container(
      height: 32,
      width: 100,
      margin: EdgeInsets.all(6),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.close_rounded),
        label: Text("Delete"),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 104, 59, 64)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );

    List boughtProducts = [];
    List notboughtProducts = [];

    void makeProductWidgets() {
      Widget divider = const Divider(
        color: Color.fromARGB(66, 255, 255, 255),
        thickness: 1,
        height: 0,
      );
      dProducts.forEach((product) {
        if (product.bought) {
          boughtProducts.add(ProductItemWidget(product, reBuild));
        } else {
          notboughtProducts.add(ProductItemWidget(product, reBuild));
        }
      });

      if (boughtProducts.isNotEmpty) {
        boughtProducts.add(divider);
      }
      if (notboughtProducts.isNotEmpty) {
        notboughtProducts.add(divider);
      }
    }

    makeProductWidgets();

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: selectedIndexNavBar == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(child: deleteButton, alignment: Alignment.centerRight),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView(children: [
                        ...notboughtProducts,
                        boughtProducts.isNotEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 5),
                                child: DeviderWidget("Bought products"),
                              )
                            : const SizedBox(),
                        ...boughtProducts,
                      ]),
                    ),
                  ),
                  SizedBox(height: 8),
                  ButtonWidget(
                      "Add product", () => gotoProductView(context, false)),
                  SizedBox(height: 8)
                ],
              )
            : ParticipantsView(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 0, 158, 142),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_rounded),
            label: "Shopping list",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            label: "Participants",
          ),
        ],
        currentIndex: selectedIndexNavBar,
        onTap: onItemTapped,
      ),
    );
  }
}
