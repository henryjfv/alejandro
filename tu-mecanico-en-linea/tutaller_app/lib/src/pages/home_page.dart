import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/loading.dart';
import 'package:tutaller_app/src/pages/shared/singleTone.dart';
import 'package:tutaller_app/src/pages/talleres/taller_main.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/styles.dart';

import 'mecanicos/mecanico-main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService db;
  Widget template = Loading();
  @override
  Widget build(BuildContext context) {
    Singleton().notificador.messageStream.listen((argumento) {
      print("========= HOME TALLERES ===========");
      print(argumento);
      /*  showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: ListTile(
                title: Text(
                  'Tu taller en línea',
                  style: CustomStyles().getStyleFontWithFontWeight(
                      Colors.black, 18.0, FontWeight.bold),
                ),
                subtitle: Text(argumento ?? ""),
              ),
            );
          }); */
    });
    final user = Provider.of<UserApp>(context);
    db = DatabaseService(uid: user.uid);
    return getWidgetPrincipal(context);
  }

  Widget getWidgetPrincipal(BuildContext context) {
    return FutureBuilder(
        future: db.esUsuarioTaller,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            bool tines = snapshot.data;
            if (tines) {
              return TallerMain();
            } else {
              return MecanicoMain();
            }
          }
          if (snapshot.hasError) {
            return Loading();
          }
          return Loading();
        });
  }
}
