import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:tutaller_app/src/providers/push_notifications_provider.dart';

typedef callBackAnidado = void Function(void Function());
typedef callBackSimple = void Function(dynamic data);

class Singleton {
  static final Singleton _singleton = Singleton._internal();
  String tipoEvento;
  LocationData currentLocation;
  double distanciaBusqueda;
  PushNotificationProvider notificador;
  callBackSimple funcionSimple;
  callBackAnidado funcionAnidada;
  bool notificacion;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  factory Singleton() {
    return _singleton;
  }

  showNotification(String title, String message) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android);
    await _singleton.flutterLocalNotificationsPlugin
        .show(0, title, message, platform);
  }

  Singleton._internal();
}
