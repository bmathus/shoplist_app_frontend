import 'package:flutter/material.dart';
import 'package:shoplist_project/customwidgets/DeviderWidget.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import './home_view.dart';
import 'package:shoplist_project/customwidgets/ProductItemWidget.dart';
import 'customwidgets/ButtonWidget.dart';
import 'package:shoplist_project/product_view.dart';
import './participants_view.dart';
import 'models/Product.dart';
import 'models/UserAuth.dart';

class ListProductsView extends StatefulWidget {
  final ShopLists lists;
  final ShopList shoplist;
  final AuthUser user;

  const ListProductsView({
    required this.shoplist,
    required this.user,
    required this.lists,
  });

  @override
  State<ListProductsView> createState() => _ListProductsViewState();
}

class _ListProductsViewState extends State<ListProductsView> {
  int selectedIndexNavBar = 0;
  bool productLoading = false;

  void gotoProductView(BuildContext ctx, bool edit) {
    Navigator.of(ctx)
        .push(
          MaterialPageRoute(
              builder: (ctx) =>
                  ProductView(widget.shoplist, edit, null, widget.user)),
        )
        .then((_) => setState(() {}));
  }

  void onNavItemTapped(int index) {
    setState(() {
      selectedIndexNavBar = index;
    });
  }

  void reBuild() => setState(() => {});

  Future<void> refreshProducts() async {
    try {
      await widget.shoplist.fetchProducts();
      setState(() {});
    } catch (e) {}
  }

  void loadProductsANDParticipants() async {
    setState(() {
      productLoading = true;
    });
    try {
      await widget.shoplist.fetchProducts();
      await widget.shoplist.fetchParticipants();
    } on Exception catch (e) {
      if (e.toString() == "Exception: No connection") {
        widget.user.showErrorDialog("No connection", context);
      } else {
        widget.user.showErrorDialog("Something went wrong", context);
      }
    }
    setState(() {
      productLoading = false;
    });
  }

  Future<void> refreshParticipants() async {
    try {
      await widget.shoplist.fetchParticipants();
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    loadProductsANDParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    AppBar appBar = AppBar(
      title: Text(widget.shoplist.name),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.home_rounded, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );

    ButtonStyle buttonstyle(Color color) => ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

    AlertDialog alert = AlertDialog(
      title: Text((widget.shoplist.num_ppl == 1 ? "Delete" : "Leave") +
          ' ${widget.shoplist.name}?'),
      content: Text('Are you sure you want to ' +
          (widget.shoplist.num_ppl == 1 ? "delete" : "leave") +
          ' ${widget.shoplist.name}?'),
      actions: <Widget>[
        ElevatedButton(
          child: Text(widget.shoplist.num_ppl == 1 ? "Delete" : "Leave"),
          style: buttonstyle(Color.fromARGB(255, 104, 59, 64)),
          onPressed: () {
            Navigator.pop(context, 'Delete');
            widget.lists.leaveList(widget.shoplist);
          },
        ),
        ElevatedButton(
          child: Text("Cancel"),
          style: buttonstyle(Color(0xFF355C7D)),
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        )
      ],
    );

    Widget deleteButton = Container(
      height: 32,
      width: 100,
      margin: EdgeInsets.all(6),
      child: ElevatedButton.icon(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            }),
        icon: Icon(Icons.close_rounded),
        label: Text(widget.shoplist.num_ppl == 1 ? "Delete" : "Leave"),
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

    Widget buildProductListUI() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(child: deleteButton, alignment: Alignment.centerRight),
          Expanded(
            child: productLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: refreshProducts,
                    child: (boughtProducts.isNotEmpty ||
                            notboughtProducts.isNotEmpty)
                        ? ListView(children: [
                            ...notboughtProducts,
                            boughtProducts.isNotEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 8, bottom: 5),
                                    child: DeviderWidget("Bought products"),
                                  )
                                : const SizedBox(),
                            ...boughtProducts,
                          ])
                        : SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/list-is-empty.png",
                                  fit: BoxFit.cover,
                                  color: Color.fromARGB(83, 89, 89, 89),
                                ),
                                SizedBox(height: 10),
                                const Text(
                                  "No products",
                                  style: TextStyle(
                                    color: Color.fromARGB(111, 89, 89, 89),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
          ),
          SizedBox(height: 8),
          ButtonWidget("Add product", () => gotoProductView(context, false)),
          SizedBox(height: 8)
        ],
      );
    }

    Widget makeProductWidgets() {
      Widget divider = const Divider(
        color: Color.fromARGB(66, 255, 255, 255),
        thickness: 1,
        height: 0,
      );
      widget.shoplist.products.forEach((product) {
        if (product.bought) {
          boughtProducts.add(ProductItemWidget(
              widget.shoplist, product, reBuild, widget.user));
        } else {
          notboughtProducts.add(ProductItemWidget(
              widget.shoplist, product, reBuild, widget.user));
        }
      });

      if (boughtProducts.isNotEmpty) {
        boughtProducts.add(divider);
      }
      if (notboughtProducts.isNotEmpty) {
        notboughtProducts.add(divider);
      }
      return buildProductListUI();
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: selectedIndexNavBar == 0
            ? makeProductWidgets()
            : RefreshIndicator(
                onRefresh: refreshParticipants,
                child: ParticipantsView(
                    user: widget.user,
                    participants: widget.shoplist.participants,
                    invite_code: widget.shoplist.invite_code),
              ),
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
        onTap: onNavItemTapped,
      ),
    );
  }
}
