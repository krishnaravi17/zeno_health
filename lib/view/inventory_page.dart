import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeno_health/database/database.dart';
import 'package:zeno_health/model/inventory.dart';
import 'package:zeno_health/model/user_inventory.dart';
import 'package:zeno_health/utils/helper.dart';
import 'package:zeno_health/view/trade_page.dart';
import 'package:zeno_health/view/user_profile.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late DataBase handler;

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    handler.initializedDB().whenComplete(() async {
      await addItemToInventory();
      await addInventoryToUser();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size? size = MediaQuery.maybeOf(context)?.size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.grey,
          title: Text(
            'ZENO HEALTH APP',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              //profile
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                  height: 20,
                  width: 20,
                  color: Colors.black,
                  image: AssetImage("assets/user_profile.webp")),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Available Inventory',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.black),
                ),
              ),
            ),
            FutureBuilder(
              future: handler.retrieveInventory(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Inventory>> snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(0),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 15,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(snapshot.data!.length, (index) {
                      return inventoryView(context, index, snapshot);
                    }),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              width: (size?.width)! * 0.80,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: onClickTrade,
                child: Text('TRADE',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //adding data to inventory table
  Future<int> addItemToInventory() async {
    Inventory obj1 = Inventory(
        id: 1, item_name: "Bat", path: "assets/cricket_bat.png", qty: 5);
    Inventory obj2 =
        Inventory(id: 2, item_name: "Ball", path: "assets/ball.png", qty: 3);
    Inventory obj3 = Inventory(
        id: 3, item_name: "Wickets", path: "assets/wicket.png", qty: 4);
    Inventory obj4 = Inventory(
        id: 4, item_name: "Guards", path: "assets/guards.png", qty: 5);
    Inventory obj5 = Inventory(
        id: 5, item_name: "Gloves", path: "assets/gloves.png", qty: 2);

    List<Inventory> inventory = [obj1, obj2, obj3, obj4, obj5];
    return await handler.insertInventory(inventory);
  }

  //adding data to user_inventory w.r.t login user
  Future<int> addInventoryToUser() async {
    UserInventory obj1 = UserInventory(
        id: 1,
        item_name: "Bat",
        item_id: 1,
        user_id: AppString().user_id,
        path: "assets/cricket_bat.png",
        qty: 3);
    UserInventory obj2 = UserInventory(
        id: 2,
        item_name: "Ball",
        item_id: 2,
        user_id: AppString().user_id,
        path: "assets/ball.png",
        qty: 3);
    UserInventory obj3 = UserInventory(
        id: 3,
        item_name: "Wickets",
        item_id: 3,
        user_id: AppString().user_id,
        path: "assets/wicket.png",
        qty: 3);

    List<UserInventory> inventory = [obj1, obj2, obj3];
    return await handler.insertUserInventory(inventory);
  }

  //adding inventory on click
  Future<int> addInventoryAsPerClick(
      String item_name, String path, int item_id, total_length) async {
    UserInventory obj1 = UserInventory(
        id: total_length + 10,
        item_name: item_name,
        item_id: item_id,
        user_id: AppString().user_id,
        path: path,
        qty: 1);

    List<UserInventory> inventory = [obj1];
    return await handler.insertUserInventory(inventory);
  }

  Widget inventoryView(BuildContext context, int index,
      AsyncSnapshot<List<Inventory>> snapshot) {
    return InkWell(
      hoverColor: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        showAlertDialog(
            context,
            snapshot.data![index].item_name.toString(),
            snapshot.data![index].path.toString(),
            snapshot.data![index].id,
            snapshot.data!.length);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: 142,
          height: 142,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 0)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(snapshot.data![index].path),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                '${snapshot.data![index].item_name.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                '(Total: ${snapshot.data![index].qty.toString()})',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showAlertDialog(BuildContext context, String item_name, String path,
      int item_id, int total_length) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you add in your profile?"),
      actions: [
        TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Item Added!");

              addInventoryAsPerClick(item_name, path, item_id, total_length);

              Navigator.of(context, rootNavigator: true).pop();
              //isYesTapped(true);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              //isYesTapped(false);
              // Navigator.of(context).pop();
            },
            child: Text("No")),
      ],
    );
    await showDialog(context: context, builder: (_) => alert);
  }

  void onClickTrade() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TradePage(),
      ),
    );
  }
}
