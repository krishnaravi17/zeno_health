import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeno_health/database/database.dart';
import 'package:zeno_health/model/user.dart';
import 'package:zeno_health/view/login_page.dart';

class Register extends StatefulWidget {
  final int userCount;
  const Register({Key? key, required this.userCount}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late DataBase handler;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _ageController = TextEditingController();

    handler = DataBase();
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
        title: Text(
          'REGISTRATION',
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
            height: 50,
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
                      hintText: 'Enter Name',
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
            margin: EdgeInsets.symmetric(vertical: 5),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ((size?.width)! * 0.80),
                  child: TextField(
                    controller: _passwordController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
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
            margin: EdgeInsets.symmetric(vertical: 5),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ((size?.width)! * 0.80),
                  child: TextField(
                    controller: _passwordConfirmController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
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
            margin: EdgeInsets.symmetric(vertical: 5),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ((size?.width)! * 0.80),
                  child: TextField(
                    controller: _ageController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter Age',
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
                    keyboardType: TextInputType.number,
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
              onPressed: signup,
              child: Text('SIGNUP',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signup() async {
    if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Name Please!!");
      return;
    }
    if (_passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Password Please!!");
      return;
    }
    if (_passwordConfirmController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Password Please!!");
      return;
    }
    if (_passwordController.text.toString() !=
        _passwordConfirmController.text.toString()) {
      Fluttertoast.showToast(msg: "Password not match!!");
      return;
    }
    if (_ageController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Age Please!!");
      return;
    }

    await addUser();
    Fluttertoast.showToast(msg: "Registered Successfully!!");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<int> addUser() async {
    User obj1 = User(
        id: widget.userCount + 1,
        user_name: _nameController.text.toString(),
        age: int.parse(_ageController.text.toString()),
        password: _passwordController.text.toString());

    List<User> user = [obj1];
    return await handler.insertUser(user);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
