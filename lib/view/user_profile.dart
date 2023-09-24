import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeno_health/database/database.dart';
import 'package:zeno_health/model/user_inventory.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late DataBase handler;
  List<UserInventory> userInventoryData = [];

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    handler.initializedDB().whenComplete(() async {
      await getUserInventoryData();
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
            'PROFILE',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              //profile
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(
                  height: 20,
                  width: 20,
                  color: Colors.white,
                  image: AssetImage("assets/back_icon.png")),
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
                  'User Inventory List',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.black),
                ),
              ),
            ),
            FutureBuilder(
              future: handler.getInventoryAsPerUser(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserInventory>> snapshot) {
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
          ],
        ),
      ),
    );
  }

  getUserInventoryData() async {
    userInventoryData = await handler.getInventoryAsPerUser();
    print('OUTPUT: ${userInventoryData.length}');
    //print('OUTPUT: ${userInventoryData[userInventoryData.length - 1].item_name}');
  }

  Widget inventoryView(BuildContext context, int index,
      AsyncSnapshot<List<UserInventory>> snapshot) {
    return InkWell(
      hoverColor: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        showAlertDialog(
          context,
          snapshot.data![index].id,
        );
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

  //removing inventory on click
  void removeInventoryAsPerClick(int inventory_id) async {
    await handler.removeUserInventoryAsPerId(inventory_id);
    await getUserInventoryData();
    setState(() {});
  }

  Future showAlertDialog(BuildContext context, int inventoryId) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do you remove?"),
      actions: [
        TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Item Removed!");

              removeInventoryAsPerClick(inventoryId);

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
}
