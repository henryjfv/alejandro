import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/singleTone.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/sistema.dart';

class ResumenDomicilio extends StatefulWidget {
  @override
  _ResumenDomicilioState createState() => _ResumenDomicilioState();
}

class _ResumenDomicilioState extends State<ResumenDomicilio> {
  UserMecanico usuario;
  String cantidadRealizada = "";

  @override
  Widget build(BuildContext context) {
    final domicilios = Provider.of<List<Domicilio>>(context) ?? [];
    final domiciliosCercanos = getDomicilioCercanos(domicilios);

    usuario = Provider.of<UserMecanico>(context) ??
        UserMecanico(nombre: 'Nombre de mecanico', email: "email@email.com");

    DatabaseService().getDomiciliosRealizados(usuario.uid).forEach((element) {
      if (cantidadRealizada == "") {
        setState(() {
          cantidadRealizada = element.length.toString();
        });
      }
    });

    return Container(
      key: UniqueKey(),
      height: 80,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 250,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Text(
                      domiciliosCercanos.length.toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: Text("Servicios en Espera",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black38, fontSize: 12.0)))),
                ]),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 1,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
            ),
          ),
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
                        cantidadRealizada,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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

  List<Domicilio> getDomicilioCercanos(List<Domicilio> domicilios) {
    var currentLocation = Singleton().currentLocation;
    double distancia = Singleton().distanciaBusqueda;
    List<Domicilio> filtro = <Domicilio>[];
    if (currentLocation != null) {
      for (int i = 0; i < domicilios.length; i++) {
        var dom = domicilios[i];
        if (dom.latitud != null &&
            dom.longitud != null &&
            dom.latitud != 0 &&
            dom.longitud != 0) {
          double lejania = SistemaTools().calculateKilometrageDistance(
              currentLocation.latitude,
              currentLocation.longitude,
              dom.latitud,
              dom.longitud);
          if (lejania <= distancia) {
            filtro.add(dom);
          }
        }
      }
    }
    return filtro;
  }
}
