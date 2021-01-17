import 'package:flutter/material.dart';
import 'ChooseList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ShoppingList.dart';
import 'Item.dart';
import 'package:shoplazy/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

BuildContext testContext;
BuildContext scaffoldContext;

class InputItem {
  String name;
  String quantity;

  InputItem({this.name, this.quantity});

  static List<InputItem> getItems() {
    return items;
  }

  static addItems(name, quantity) {
    var item = new InputItem();
    item.name = name;
    item.quantity = quantity;
    items.add(item);
  }
}

List<InputItem> items = [];
var currentUser = ShoppingList(userEmail);

class ShoppingTable extends StatefulWidget {
  ShoppingTable() : super();

  @override
  ShoppingTableState createState() => ShoppingTableState();
}

class ShoppingTableState extends State<ShoppingTable> {
  List<InputItem> items;
  List<InputItem> selectedItems;
  bool pressed;

  @override
  void initState() {
    super.initState();
    selectedItems = [];
    items = InputItem.getItems();
    pressed = false;
  }

  onSelectedItem(bool selected, InputItem item) async {
    setState() {
      if (selected == true) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    }
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5),
            child: OutlinedButton(
              child: Text('Add Another Item'),
              onPressed: () {
                var item = new InputItem();
                item.name = "";
                item.quantity = "";
                items.add(item);
                setState(() {});
                pressed = true;
              },
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: DataTable(
              showCheckboxColumn: false,
              sortColumnIndex: 0,
              columns: [
                DataColumn(
                  label: Text("Item"),
                ),
                DataColumn(
                  label: Text("Quantity"),
                ),
              ],
              rows: items
                  .map(
                    (item) => DataRow(
                        selected: selectedItems.contains(item),
                        onSelectChanged: (b) {
                          onSelectedItem(b, item);
                        },
                        cells: [
                          DataCell(
                            TextField(
                              onChanged: (text) {
                                item.name = text;
                              },
                            ),
                          ),
                          DataCell(TextField(
                            onChanged: (quantity) {
                              item.quantity = quantity;
                              addToShoppingList(
                                  pressed, item.name, item.quantity);
                            },
                          )),
                        ]),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    testContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Selected Items"),
        actions: <Widget>[
          IconButton(
            onPressed: () => _signOut(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            //verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: dataBody(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      child: Text('Checkout'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Checkout"),
                            content: Text("Confirm checkout?"),
                            actions: [
                              OutlinedButton(
                                  onPressed: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                  child: Text("No")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    createSnackBar("Shopping List Submitted!");
                                  },
                                  child: Text("Yes")),
                            ],
                          ),
                          barrierDismissible: true,
                        );
                        //TODO: Store the data to the database and optionally transition
                      },
                    ),
                  ),
                ],
              ),
            ]);
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: onItemTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Shop',
          ),
        ],
      ),
    );
  }

  void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.red);

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }
}

void _signOut(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void onItemTap(int index) {
  if (index == 1) {
    Navigator.push(
        testContext, MaterialPageRoute(builder: (context) => ChooseList()));
  }
}

void addToShoppingList(bool pressed, String name, String quantity) {
  if (pressed == true) {
    int quant = int.tryParse(quantity);
    if (quant != null) {
      var newItem = new Item(name, quant, "");
      currentUser.addItem(newItem);
    }
    pressed = false;
  }
}

final _auth = FirebaseAuth.instance;
String userEmail;
void getCurrentUserEmail() async {
  final user = _auth.currentUser;
  userEmail = user.email;
}

//TODO: Implement the functionality for users to input their desired items.
// Try using DataTable
class InputItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShoppingTable();
  }
}
