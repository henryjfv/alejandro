import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutaller_app/src/utils/styles.dart';

typedef callBack = void Function(String respuesta);

class SistemaTools {
  callBack funcion;

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

  void inputDialog(BuildContext context, titulo, mensaje, callBack) {
    String dialogText;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(titulo),
          content: TextField(
            onChanged: (String textTyped) {
              dialogText = textTyped;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: mensaje),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Row(
              children: <Widget>[
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                    onPressed: () {
                      if (callBack != null) {
                        callBack(dialogText);
                      }
                      Navigator.of(context).pop();
                    },
                    child: new Text("Aceptar"))
              ],
            ),
          ],
        );
      },
    );
  }

  double calculateKilometrageDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
