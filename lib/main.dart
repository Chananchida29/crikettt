import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:newtest/provider/notification_provider.dart';
import 'package:newtest/screen/Money/provider/money_provider.dart';
import 'package:newtest/screen/first_screen.dart';
import 'package:newtest/screen/notification/notification_list_screen.dart';
import 'package:newtest/screen/user/firebaselogin.dart';
import 'package:newtest/services/local_notification_service.dart';
import 'package:newtest/setup/notification_set_up.dart';
import 'package:provider/provider.dart';

import 'config/constant.dart';
import 'config/my_input_theme.dart';
import 'screen/createCricket/createCricket.dart';
import 'screen/Cricket/viewcricket.dart';
import 'screen/Money/viewdata.dart';
import 'screen/dashboard.dart';
import 'screen/user/firebaseregister.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SetUpNotification.notificationSetup();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<MoneyProvider>(create: (context) => MoneyProvider()),
    ChangeNotifierProvider<NotificationProvider>(create: (context) => NotificationProvider()..getNotificationList()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // In this example, suppose that all messages contain a data field with the key 'type'.
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationListPage(),
        ));
  }

  @override
  void initState() {
    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
      routes: {
        'Index': (context) => FirstScreen(),
        'Login': (context) => FirebaseLogin(),
        'Register': (context) => FirebaseRegister(),
        'Dashboard': (context) => Dashboard(),
        'ViewData': (context) => ViewData(),
        'ViewCricket': (context) => ViewCricket(),
        'CreateCricket': (context) => CreateEditCricket(),
      },
      builder: EasyLoading.init(),
      theme: ThemeData(
        primaryColor: sColor,
        secondaryHeaderColor: sColor,
        inputDecorationTheme: MyInputTheme().theme(),
        unselectedWidgetColor: pColor,
      ),
      localizationsDelegates: [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}
