import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/HistorialModel/HistorialDomicilio.dart';
import 'package:mecanico_app/src/models/HistorialModel/HistorialServicio.dart';
import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:mecanico_app/src/models/servicio.dart';
import 'package:mecanico_app/src/pages/DetalleServicio.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/pages/shared/loading.dart';
import 'package:mecanico_app/src/pages/wrapper.dart';
import 'package:mecanico_app/src/pages/wrapperDomicilio.dart';
import 'package:mecanico_app/src/utils/AppBarConfig.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:mecanico_app/src/utils/utils.dart';

class ServiciosTomados extends StatefulWidget {
  ServiciosTomados({Key key}) : super(key: key);

  @override
  _ServiciosTomadosState createState() => _ServiciosTomadosState();
}

class _ServiciosTomadosState extends State<ServiciosTomados> {
  String id = FirebaseAuth.instance.currentUser.uid.toString();
  DatabaseService db = DatabaseService();
  String cantidad = "0";
  int idActivos = 100;
  int idHistoricos = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar('Mira tus servicios tomados'),
      body: Column(
        children: [
/*           Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Por el momento no has tomado ningún servicio',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), */
          Expanded(
            child: itemServicio(),
          ),
        ],
      ),
    );
  }

  Widget itemServicio() {
    return FutureBuilder(
        future: Future.wait([
          db.getDomicilioUsuario(id),
          db.getServicioUsuario(id),
        ]),
        builder: (context, doc) {
          if (doc.hasData && doc.data != null) {
            List<Widget> items = [];

            for (var lista in doc.data) {
              if (lista is List<Domicilio>) {
                for (var item in lista) {
                  int idItem = idHistoricos;
                  if (item.estado == EstadoDomicilio.Creado ||
                      item.estado == EstadoDomicilio.Tomado) {
                    idItem = idActivos;
                  }
                  items.add(HistorialDomicilio(
                          key: Key(idItem.toString()), domiclio: item)
                      .buildDomicilio(context));
                  idHistoricos++;
                  idActivos++;
                }
              }
              if (lista is List<Servicio>) {
                for (var item in lista) {
                  int idItem = idHistoricos;
                  if (item.estado == EstadoServicio.Creado ||
                      item.estado == EstadoServicio.Tomado) {
                    idItem = idActivos;
                  }
                  items.add(HistorialServicio(
                          key: Key(idItem.toString()), servicio: item)
                      .buildServicio(context));
                  idHistoricos++;
                  idActivos++;
                }
              }
            }
            items.sort((a, b) =>
                a.key.toString().length.compareTo(b.key.toString().length));
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    items.length.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Historial de servicios'),
                  ...items
                ],
              ),
            );
          } else {
            /* return Loading(); */
            return Container(
              child: Align(
                  alignment: Alignment.center,
                  child: Text("No hay información para mostrar")),
            );
          }
        });
  }

  List<Widget> getOrderCartas(List<Widget> cartas) {
    cartas.sort(
        (a, b) => a.key.toString().length.compareTo(b.key.toString().length));
    return cartas;
  }

  Widget _appBar(title) {
    return AppBar(
      flexibleSpace: Container(
        decoration: decoracionCurvaGradientAppBar,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 17.0),
      ),
      actions: AccionesToolbar(context: context).getAcciones(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(50),
        ),
      ),
    );
  }
}
