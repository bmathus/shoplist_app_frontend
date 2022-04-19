import 'package:flutter/material.dart';
import 'package:shoplist_project/customwidgets/DeviderWidget.dart';
import 'package:shoplist_project/models/ShopLists.dart';
import 'package:shoplist_project/models/Call.dart';
import 'package:shoplist_project/customwidgets/ProductItemWidget.dart';
import '../customwidgets/ButtonWidget.dart';
import 'package:shoplist_project/views/product_view.dart';
import 'participants_view.dart';
import '../models/UserAuth.dart';

//widget obrazovky zoznamu produktov v nakupnom zozname
class ListProductsView extends StatefulWidget {
  final ShopLists lists;
  final ShopList shoplist;
  final AuthUser user;

  ListProductsView({
    required this.shoplist,
    required this.user,
    required this.lists,
  });

  @override
  State<ListProductsView> createState() => _ListProductsViewState();
}

class _ListProductsViewState extends State<ListProductsView> {
  int selectedIndexNavBar =
      0; //ak 0 tak obrazovka zoznamu ak 1 tak obrazovka participantov
  bool productLoading = false; //indikator nacitavania pri staceni tlacidla

  //funkcia na navigaciu na obrazovku detailu produktu
  void gotoProductView(BuildContext ctx, bool edit) {
    Navigator.of(ctx)
        .push(
          MaterialPageRoute(
              builder: (ctx) => ProductView(
                    widget.shoplist,
                    edit,
                    null,
                  )),
        )
        .then((_) => setState(
            () {})); //po vrateni spat na obrazovku zoznamu rebuild obrazovky
  }

  void onNavItemTapped(int index) {
    setState(() {
      selectedIndexNavBar = index;
    });
  }

  //funkcia na rebuild obrazovky
  void reBuildThisView() => setState(() => {});

  //funkcia na refresh produktov teda volanie na backend pri swipe down
  Future<void> refreshProducts() async {
    try {
      await widget.shoplist.fetchProducts();
      setState(() {});
    } catch (e) {}
  }

  //funckia na nacitanie vsetkych produktov a participantov z backendu
  //a vhladom na odpovede volani updatovanie UI
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

  //funckia na refresh obrazovky participantov pri swipe down
  //teda volanie na fetchnutie participantov z backendu
  Future<void> refreshParticipants() async {
    try {
      await widget.shoplist.fetchParticipants();
      setState(() {});
    } catch (e) {}
  }

  //pri prvom builde widgetu nacitanie produktov a participantov z backendu
  @override
  void initState() {
    loadProductsANDParticipants();
    super.initState();
  }

  //funkcia na volanie endpointu na vymazanie/leavnutie zoznamu
  void leaveOrDeleteList(BuildContext context) async {
    Navigator.pop(context, 'Delete');
    try {
      await widget.lists.leaveList(widget.shoplist);
    } catch (e) {}
    Navigator.pop(context);
  }

  //build funkcia obrazovky
  @override
  Widget build(BuildContext context) {
    //widget appbaru
    AppBar appBar = AppBar(
      title: Text(widget.shoplist.name),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.home_rounded, size: 30),
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

    //widget dialogoveho okna v pripade vymazania/leavnutia zoznamu
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
            leaveOrDeleteList(context);
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

    //widget buttonu na vymazanie/leavnutie zoznamu
    Widget deleteButton = Container(
      height: 32,
      width: 100,
      margin: const EdgeInsets.all(6),
      child: ElevatedButton.icon(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            }),
        icon: const Icon(Icons.close_rounded),
        label: Text(widget.shoplist.num_ppl == 1 ? "Delete" : "Leave"),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 104, 59, 64)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );

    //pomocne listy na rozdelenie widgetov produktov na zakupene a nezakupene
    List boughtProducts = [];
    List notboughtProducts = [];

    //funkcia buldnutia UI obrazovk
    Widget buildProductListUI() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(child: deleteButton, alignment: Alignment.centerRight),
          Expanded(
            child: productLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF355C7D),
                    ),
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
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 30),
                                Image.asset(
                                  "assets/list-is-empty.png",
                                  fit: BoxFit.cover,
                                  color: Color.fromARGB(83, 89, 89, 89),
                                ),
                                const SizedBox(height: 10),
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
          const SizedBox(height: 8),
          ButtonWidget("Add product", () => gotoProductView(context, false)),
          const SizedBox(height: 8)
        ],
      );
    }

    //widget funkcia ktora rozdeluje widgety produktov a zostavuje ich UI
    Widget makeProductWidgets() {
      Widget divider = const Divider(
        color: Color.fromARGB(66, 255, 255, 255),
        thickness: 1,
        height: 0,
      );
      widget.shoplist.products.forEach((product) {
        if (product.bought) {
          boughtProducts.add(
              ProductItemWidget(widget.shoplist, product, reBuildThisView));
        } else {
          notboughtProducts.add(
              ProductItemWidget(widget.shoplist, product, reBuildThisView));
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

    //return build funkcia
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
                  invite_code: widget.shoplist.invite_code,
                  call: Call(token: widget.user.token),
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 0, 158, 142),
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
