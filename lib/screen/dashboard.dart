import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:newtest/screen/Cricket/viewcricket.dart';
import 'package:newtest/screen/Money/viewdata.dart';
import 'package:newtest/screen/dialog_flow/dialog_flow_chat.dart';
import 'package:newtest/screen/home/home.dart';
import 'package:newtest/screen/profile.dart';

class Dashboard extends StatefulWidget {
  // const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;

  final screens = [
    Home(),
    DialogFlowChat(),
    ViewCricket(),
    ViewData(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home_rounded, size: 30, color: Colors.white),
      Icon(Icons.chat_rounded, size: 30, color: Colors.white),
      Icon(Icons.dashboard_customize_rounded, size: 30, color: Colors.white),
      Icon(Icons.attach_money_rounded, size: 30, color: Colors.white),
      Icon(Icons.person_rounded, size: 30, color: Colors.white),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xFFEAEED7),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        buttonBackgroundColor: Color(0xFF8D9D43),
        color: Color(0xFF9C5F28),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        height: 60,
        index: index,
        items: items,
        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}
