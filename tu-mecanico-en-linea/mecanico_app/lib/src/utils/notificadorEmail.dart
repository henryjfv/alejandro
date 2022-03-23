import 'package:flutter_email_sender/flutter_email_sender.dart';

class NotificadorEmail {
  List<String> attachments = [];
  bool isHTML = false;

  String destinatario = "";
  String asunto = "";
  String cuerpo = "";

  NotificadorEmail({this.destinatario, this.asunto, this.cuerpo, this.isHTML});

  Future<String> send() async {
    final Email email = Email(
      body: cuerpo,
      subject: asunto,
      recipients: [destinatario],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    return platformResponse;
  }
}
