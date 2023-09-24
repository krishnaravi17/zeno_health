import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeno_health/database/database.dart';
import 'package:zeno_health/model/inventory.dart';
import 'package:zeno_health/model/user.dart';
import 'package:zeno_health/model/user_inventory.dart';

class TradePage extends StatefulWidget {
  const TradePage({Key? key}) : super(key: key);

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  late DataBase handler;
  List<UserInventory> userInventoryData = [];

  var colorPrimary = Color(0xFFe55f19);
  var colorwhite = Color(0xFFeffffff);
  var checkTr = true;
  static List<User> allUsersList = [];

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    handler.initializedDB().whenComplete(() async {
      await getAllUser();
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
            'TRADE',
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
              padding: const EdgeInsets.only(
                  top: 30, bottom: 0, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      checkTr = true;
                      colorPrimary = Color(0xFFe55f19);
                      colorwhite = Color(0xFFffffff);
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Text(
                          "BUY",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          color: colorPrimary,
                          height: 3,
                        )
                      ],
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      checkTr = false;
                      colorPrimary = Color(0xFFffffff);
                      colorwhite = Color(0xFFe55f19);
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Text(
                          "SELL",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          color: colorwhite,
                          height: 3,
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
            //BUY VIEW
            Visibility(
              visible: checkTr,
              child: FutureBuilder(
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
            ),
            //SELL VIEW
            Visibility(
              visible: !checkTr,
              child: FutureBuilder(
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
                        return inventoryListAsPerUserView(
                            context, index, snapshot);
                      }),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAllUser() async {
    allUsersList = await handler.getAllUsers();
    print('OUTPUT: ${allUsersList.length}');
  }

  //master inventory list
  Widget inventoryView(BuildContext context, int index,
      AsyncSnapshot<List<Inventory>> snapshot) {
    return InkWell(
      hoverColor: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        alertForUserList(context);
        /* showAlertDialog(
          context,
          snapshot.data![index].id,
        );*/
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

  //user's inventory list
  Widget inventoryListAsPerUserView(BuildContext context, int index,
      AsyncSnapshot<List<UserInventory>> snapshot) {
    return InkWell(
      hoverColor: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        sellPopUpToSendRequestAllMember(
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

  Future sellPopUpToSendRequestAllMember(
      BuildContext context, int inventoryId) async {
    AlertDialog alert = AlertDialog(
      elevation: 24,
      content: Text("Do want to sell this item?"),
      actions: [
        TextButton(
            onPressed: () {
              Fluttertoast.showToast(
                  msg: "Sell request hase been sent to all users!");
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

  //popup
  static void alertForUserList(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/hole_popup_bg.png"))),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 500,
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.only(top: 25, bottom: 10),
                elevation: 0,
                //color: AppColor().wallet_dark_grey,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 0, top: 10, bottom: 0),
                        child: Text(
                          'Select User from whom to buy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                      ListView.builder(
                        itemCount: allUsersList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              Fluttertoast.showToast(
                                  msg:
                                      "Buy request has been sent to ${allUsersList[index].user_name}!");
                            },
                            leading: Text(
                              allUsersList[index].user_name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }
}
