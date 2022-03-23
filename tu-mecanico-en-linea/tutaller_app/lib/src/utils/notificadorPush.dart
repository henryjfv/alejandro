// Replace with server token from firebase console settings.
import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
final String serverToken =
    'AAAAg13zJuI:APA91bEeWyarTglC7SO01yKj94xVLpZQvKXQ0esIr0n1gTRyZ7Q-O-cPKTDbAjlaSa3YKAr-c4MeRfUQPWcHgpq7TSWvFqkzQBH4EB129IJgnKMlieVfDNDxOG1QZhv_GLGvBxq7WB6A';

Future<Map<String, dynamic>> sendAndRetrieveMessage(String token) async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'this is a body',
          'title': 'this is a title'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'comida': 'carne asada'
        },
        'to': token,
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    },
  );

  return completer.future;
}
