import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/utils/dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> logout() async {
    try {
      await EasyLoading.show();
      await FirebaseAuth.instance.signOut();
      await EasyLoading.dismiss();
      Navigator.pop(context);
    } catch (e) {
      await EasyLoading.dismiss();
      AlertUtils.dialogAlert(context: context, subTitle: e.toString());
    }
  }

  FirebaseAuth get auth => FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: pColor,
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    auth.currentUser.displayName,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    auth.currentUser.email,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sColor,
                    padding: EdgeInsets.fromLTRB(120, 15, 120, 15),
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    await logout();
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, 'Index', arguments: []);
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
