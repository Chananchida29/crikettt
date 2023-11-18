import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../config/constant.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Welcome to Cricket App",
                  style: TextStyle(
                    color: pColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    "asset/image/main.png",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: sColor,
                      padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                      shape: StadiumBorder(),
                      fixedSize: const Size(300, 50)),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'Login');
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: sColor,
                      padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                      shape: StadiumBorder(),
                      fixedSize: const Size(300, 50)),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'Register');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
