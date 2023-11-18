// ignore_for_file: missing_return

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/screen/dashboard.dart';
import 'package:newtest/screen/user/firebaselogin.dart';
import 'package:newtest/utils/dialog.dart';

class FirebaseRegister extends StatefulWidget {
  @override
  _FirebaseRegisterState createState() => _FirebaseRegisterState();
}

class _FirebaseRegisterState extends State<FirebaseRegister> {
  TextEditingController nameController;
  TextEditingController surnameController;
  TextEditingController emailController;
  TextEditingController passwordController1;
  TextEditingController passwordController2;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController1 = TextEditingController();
    passwordController2 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pColor,
          title: Text('Register User to Firebase'),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                txtName(),
                txtSurname(),
                txtEmail(),
                txtPassword1(),
                txtPassword2(),
                btnSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget txtName() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: TextFormField(
        controller: nameController,
        style: TextStyle(
          fontSize: 24,
          color: pColor,
        ),
        decoration: InputDecoration(
          labelText: 'Name:',
          icon: Icon(Icons.account_circle),
          hintText: 'Input your name',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณาใส่ข้อมูลด้วย';
          } else if (value.length < 2) {
            return 'กรุณาใส่ข้อมูลมากกว่า 2 ตัวอักษร';
          }
        },
      ),
    );
  }

  Widget txtSurname() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: TextFormField(
        controller: surnameController,
        style: TextStyle(
          fontSize: 24,
          color: pColor,
        ),
        decoration: InputDecoration(
          labelText: 'Surname:',
          icon: Icon(Icons.add_reaction_sharp),
          hintText: 'Input your surname',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
        },
      ),
    );
  }

  Widget txtEmail() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 24,
          color: pColor,
        ),
        decoration: InputDecoration(
          labelText: 'Email:',
          icon: Icon(Icons.email),
          hintText: 'Input your email',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          } else if (!EmailValidator.validate(value)) {
            return 'กรุณากรอกข้อมูลตามรูปแบบอีเมลด้วย';
          }
        },
      ),
    );
  }

  Widget txtPassword1() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: TextFormField(
        controller: passwordController1,
        obscureText: true,
        style: TextStyle(
          fontSize: 24,
          color: pColor,
        ),
        decoration: InputDecoration(
          labelText: 'Password:',
          icon: Icon(Icons.lock),
          hintText: 'Input your password',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          } else if (value.length < 6) {
            return 'รหัสผ่านควรมีขั้นต่ำ 6 ตัว';
          } else if (value.trim() != passwordController2.text.trim()) {
            return 'password not match';
          }
        },
      ),
    );
  }

  Widget txtPassword2() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: TextFormField(
        controller: passwordController2,
        obscureText: true,
        style: TextStyle(
          fontSize: 24,
          color: pColor,
        ),
        decoration: InputDecoration(
          labelText: 'Password:',
          icon: Icon(Icons.lock),
          hintText: 'Input your password',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          } else if (value.length < 6) {
            return 'รหัสผ่านควรมีขั้นต่ำ 6 ตัว';
          } else if (value.trim() != passwordController1.text.trim()) {
            return 'password not match';
          }
        },
      ),
    );
  }

  Widget btnSubmit() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: sColor,
            padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
            shape: StadiumBorder(),
            fixedSize: const Size(200, 50)),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();

            await registerFirebase();
          }
        },
        child: Text('SAVE'),
      );

  Future<void> registerFirebase() async {
    try {
      await EasyLoading.show();
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController1.text.trim());
      await FirebaseAuth.instance.currentUser.updateDisplayName(
          '${nameController.text.trim()} ${surnameController.text.trim()}');
      await EasyLoading.dismiss();
      if (credential.additionalUserInfo.isNewUser) {
        AlertUtils.dialogAlert(
            context: context,
            icon: const Icon(
              Icons.check,
              color: Colors.green,
              size: 48,
            ),
            title: 'สำเร็จ',
            subTitle: 'สร้างบัญชีสำเร็จ',
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
            title: 'บัญชีนี้มีในระบบอยู่แล้ว',
            textButton: 'ปิด',
            onPress: () {
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => FirebaseLogin());
              Navigator.of(context).pushAndRemoveUntil(
                  materialPageRoute, (Route<dynamic> route) => false);
            });
      }
    } catch (e) {
      await EasyLoading.dismiss();
      AlertUtils.dialogAlert(context: context, subTitle: e.toString());
    }
  }
}
