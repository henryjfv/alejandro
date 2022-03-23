import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/singleTone.dart';
import 'package:tutaller_app/src/pages/wrapper.dart';
import 'package:tutaller_app/src/providers/push_notifications_provider.dart';
import 'package:tutaller_app/src/utils/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(Inicio());
}

class Inicio extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  void initState() {
    super.initState();
    loadNotification();
  }

  Future<void> loadNotification() {
    Singleton().notificacion = false;
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();
    Singleton().notificador = pushProvider;
    Singleton().flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings =
        InitializationSettings(android: initializationSettingsAndroid);

    Singleton().flutterLocalNotificationsPlugin.initialize(initSetttings);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tu taller en línea',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserApp>.value(
      value: AuthProvider().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
