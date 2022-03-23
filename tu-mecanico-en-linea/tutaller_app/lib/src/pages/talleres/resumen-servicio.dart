import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/servicio.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';

class ResumenServicio extends StatefulWidget {
  @override
  _ResumenServicioState createState() => _ResumenServicioState();
}

class _ResumenServicioState extends State<ResumenServicio> {
  @override
  Widget build(BuildContext context) {
    final servicios = Provider.of<List<Servicio>>(context) ?? [];

    return Container(
      height: 80,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 250,
            child: Column(
                key: UniqueKey(),
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      child: Text(
                          servicios
                              .where((e) => e.estado == EstadoServicio.Creado)
                              .toList()
                              .length
                              .toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)))),
                  Container(
                      width: double.infinity,
                      child: Text("Cliente(s)",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black38, fontSize: 12.0)))),
                ]),
          ),
          Expanded(
              flex: 1,
              child: Container(
                  width: double.infinity,
                  height: 115.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ))),
          Expanded(
              flex: 250,
              child: Column(
                  key: UniqueKey(),
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      key: UniqueKey(),
                      width: double.infinity,
                      child: Text(
                          servicios
                              .where(
                                  (e) => e.estado == EstadoServicio.Terminado)
                              .toList()
                              .length
                              .toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))),
                    ),
                    Container(
                        width: double.infinity,
                        child: Text("Servicios realizados con la app",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black38, fontSize: 12.0)))),
                  ])),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey[300], spreadRadius: 1),
        ],
      ),
    );
  }
}
