import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mecanico_app/src/utils/styles.dart';

class SistemaTools {
  void mostrarAlert(BuildContext context, titulo, mensaje) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              titulo,
              style: CustomStyles().getStyleFont(Colors.black, 18.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  mensaje,
                  style: CustomStyles().getStyleFont(Colors.black, 15.0),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}
