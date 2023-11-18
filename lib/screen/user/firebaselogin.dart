import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/screen/dashboard.dart';
import 'package:newtest/utils/dialog.dart';
// ignore_for_file: missing_return

class FirebaseLogin extends StatefulWidget {
  @override
  _FirebaseLoginState createState() => _FirebaseLoginState();
}

class _FirebaseLoginState extends State<FirebaseLogin> {
  TextEditingController emailController;
  TextEditingController passwordController;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  Future<void> checkUser() async {
    try {
      await EasyLoading.show();
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim().toString(),
              password: passwordController.text.trim().toString());
      await EasyLoading.dismiss();
      if (credential.user != null) {
        AlertUtils.dialogAlert(
            context: context,
            icon: const Icon(
              Icons.check,
              color: Colors.green,
              size: 48,
            ),
            title: 'Login Success',
            subTitle: 'ทำการเข้าสู่ระบบ',
            textButton: 'ต่อไป',
            onPress: () {
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard());
              Navigator.of(context).pushAndRemoveUntil(
                  materialPageRoute, (Route<dynamic> route) => false);
            });
      } else {
        AlertUtils.dialogAlert(
            context: context,
            subTitle: 'กรุณาลองใหม่อีกครั้ง',
            textButton: 'ปิด',
            onPress: () {
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => FirebaseLogin());
              Navigator.of(context).pushAndRemoveUntil(
                  materialPageRoute, (Route<dynamic> route) => false);
            });
      }
    } on FirebaseAuthException catch (e) {
      await EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        AlertUtils.dialogAlert(
          context: context,
          subTitle: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        AlertUtils.dialogAlert(
            context: context,
            subTitle: 'Wrong password provided for that user.');
      } else {
        AlertUtils.dialogAlert(context: context, subTitle: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pColor,
        ),
        body: Form(
          key: formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Cricket Login Firebase',
                    style: TextStyle(fontSize: 25, color: pColor),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    width: size.width * 0.9,
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.alternate_email,
                          color: pColor,
                          size: size.height * 0.05,
                        ),
                        hintText: "Email",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณาใส่ข้อมูลด้วย';
                        } else if (value.length < 2) {
                          return 'กรุณาใส่ข้อมูลมากกว่า 2 ตัวอักษร';
                        } else if (!EmailValidator.validate(value)) {
                          return 'กรุณากรอกข้อมูลตามรูปแบบอีเมลด้วย';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: size.width * 0.9,
                    child: TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: pColor,
                          size: size.height * 0.05,
                        ),
                        hintText: "Password",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณากรอกข้อมูล';
                        } else if (value.length < 6) {
                          return 'รหัสผ่านควรมีขั้นต่ำ 6 ตัว';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    width: size.width * 0.8,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          await checkUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: pColor)),
                        foregroundColor: Colors.white,
                        backgroundColor: pColor,
                      ),
                      child: Text("login".toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'Register');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        color: sColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'All rights reserved',
                    style: TextStyle(
                      fontSize: 16,
                      color: sColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
