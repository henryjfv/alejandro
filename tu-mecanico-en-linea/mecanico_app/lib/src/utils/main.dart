import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/home_page.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';
import 'package:mecanico_app/src/providers/push_notifications_provider.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/firebase_auth.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  loadNotification();
  runApp(MyApp());
}

Future<void> loadNotification() {
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tu mecánico en línea',
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0))),
      home: Stack(
        children: [
          MainScreen(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 20.0),
              child: ButtonTheme(
                height: 40.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: Color(0xff25D366),
                    ),
                  ),
                  textColor: Colors.white,
                  color: Color(0xff25D366),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ayuda',
                        style: CustomStyles().getStyleFont(Colors.white, 12.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: FaIcon(FontAwesomeIcons.whatsapp),
                      )
                    ],
                  ),
                  onPressed: () => _openWhatsApp(context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void _openWhatsApp(BuildContext context) async {
  Configuracion config = await DatabaseService().configuracion;
  String url = 'whatsapp://send?phone=' +
      config.telefonoWhatsAppAyuda +
      '&text=' +
      config.mensajeWhatsappAyuda;
  await canLaunch(url)
      ? launch(url)
      : SistemaTools()
          .mostrarAlert(context, '¡Lo sentimos!', 'No podemos abrir WhatsApp');
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserApp>.value(
      value: AuthProvider().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0),
          ),
        ),
      ),
    );
  }
}

//CARLOS GONZALEZ, HENRY FERNANDEZ 1 SEP 2020
