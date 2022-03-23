import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:http/http.dart' as http;

final String serverToken =
    'AAAAg13zJuI:APA91bEeWyarTglC7SO01yKj94xVLpZQvKXQ0esIr0n1gTRyZ7Q-O-cPKTDbAjlaSa3YKAr-c4MeRfUQPWcHgpq7TSWvFqkzQBH4EB129IJgnKMlieVfDNDxOG1QZhv_GLGvBxq7WB6A';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

class PushNotificationProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final StreamController<String> _messageStreamController =
      StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageStreamController.stream;

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("=========== BACKGROUND MESSAGE NOTIFICATION =========");
    print(message);
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initNotifications() async {
    await _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((value) async {
      print("========= FCM token ===========");
      print(value);
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser.uid != null) {
        String idUser = FirebaseAuth.instance.currentUser.uid.toString();
        await DatabaseService().updateTokenUserData(idUser, value);
      }
    });

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: onLaunch,
      onResume: onResumen,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print('======= on Message =========');
    final argumento = message["notification"]["body"];
    print(argumento);
    final title = message["notification"]["title"];
    Singleton().showNotification(
        title ?? 'Tu mecanico en linea', argumento ?? 'Notificación');
    _messageStreamController.add(argumento);
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('======= onLaunch =========');
    //print('message: $message');
    final argumento = message["notification"]["body"];
    _messageStreamController.add(argumento);
  }

  Future<dynamic> onResumen(Map<String, dynamic> message) async {
    print('======= onResumen =========');
//    print('message: $message');

    final argumento = message["notification"]["body"];
    _messageStreamController.add(argumento);
  }

  dispose() {
    _messageStreamController?.close();
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(
      String token, String titulo, String contenido) async {
    try {
      await firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );

      await http
          .post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': contenido,
              'title': titulo
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': '$token'
          },
        ),
      )
          .then((value) {
        print(json.decode(value.body));
      });

      /* final Completer<Map<String, dynamic>> completer =
          Completer<Map<String, dynamic>>();

      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          completer.complete(message);
        },
      ); */

      return null;
    } catch (e) {
      print('-------------------- ERROR NOTIFICACION ----------------');
      print(e);
      return null;
    }
  }
}
