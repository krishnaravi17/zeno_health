import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeno_health/database/database.dart';
import 'package:zeno_health/model/user.dart';
import 'package:zeno_health/utils/helper.dart';
import 'package:zeno_health/view/inventory_page.dart';
import 'package:zeno_health/view/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late DataBase handler; //database instance
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  List<User> allUsersList = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();

    handler = DataBase();
    handler.initializedDB().whenComplete(() async {
      await addUsers(); //adding some user for better flow
      await getAllUser(); //to get all user
    });
  }

  @override
  Widget build(BuildContext context) {
    Size? size = MediaQuery.maybeOf(context)?.size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: const Text(
          'LOGIN',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ((size?.width)! * 0.80),
                  child: TextField(
                    controller: _nameController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ((size?.width)! * 0.80),
                  child: TextField(
                    controller: _passwordController,
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            width: (size?.width)! * 0.80,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
              ),
              onPressed: login,
              child: Text('Login',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
          Text(
            'OR',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            width: (size?.width)! * 0.80,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
              ),
              onPressed: signup,
              child: Text('Register',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> addUsers() async {
    User obj1 = User(id: 1, user_name: "Arpit", age: 20, password: "123456");
    User obj2 = User(id: 2, user_name: "Ravi", age: 22, password: "123456");
    User obj3 = User(id: 3, user_name: "Vivek", age: 25, password: "123456");
    User obj4 = User(id: 4, user_name: "Rishabh", age: 21, password: "123456");
    User obj5 = User(id: 5, user_name: "Shantanu", age: 29, password: "123456");

    List<User> user = [obj1, obj2, obj3, obj4, obj5];
    return await handler.insertUser(user);
  }

  getAllUser() async {
    allUsersList = await handler.getAllUsers();
    print('OUTPUT: ${allUsersList[allUsersList.length - 1].user_name}');
    print('OUTPUT: ${allUsersList.length}');
  }

  void login() {
    //Fluttertoast.showToast(msg: "Enter Name Please!!");
    if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Name Please!!");
      return;
    }
    if (_passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Name Password!!");
      return;
    }
    bool checkForLogin = false;
    for (User user in allUsersList) {
      print('login trying ---> ${user.user_name}');
      if (user.user_name.toLowerCase() == _nameController.text.toLowerCase() &&
          user.password.toString() == _passwordController.text.toString()) {
        print('login  ---> ${user.user_name}');
        AppString().user_id = user.id;
        AppString().user_name = user.user_name;
        checkForLogin = true;
        break;
      }
    }
    //checking credentials
    if (checkForLogin == true) {
      Fluttertoast.showToast(msg: "Login Successful!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InventoryPage(),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Wrong credentials entered!");
    }
  }

  void signup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(userCount: allUsersList.length),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
