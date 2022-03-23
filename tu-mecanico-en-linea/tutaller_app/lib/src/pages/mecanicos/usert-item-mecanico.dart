import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/mecanicos/resumen-domicilio.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';

import 'domicilio-list-item.dart';

typedef callBackPrincipal = void Function(void Function());

class UserMecanicoItem extends StatefulWidget {
  UserMecanicoItem(this.funcion);
  callBackPrincipal funcion;
  @override
  _UserMecanicoItemState createState() => _UserMecanicoItemState();
}

class _UserMecanicoItemState extends State<UserMecanicoItem> {
  UserMecanico usuario;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserMecanico>(context) ??
        UserMecanico(nombre: 'Nombre de mecanico', email: "email@email.com");
    width = MediaQuery.of(context).size.width;

    return Container(
        child: Container(
      child: StreamProvider<List<Domicilio>>.value(
        key: UniqueKey(),
        value: DatabaseService().getDomiciliosActivos(usuario.uid),
        child: Column(
          key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 300.0),
            Center(
                child: Text(usuario.nombre,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        textStyle:
                            TextStyle(color: Colors.black, fontSize: 18.0)))),
            Center(
                child: Text(usuario.email,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        textStyle:
                            TextStyle(color: Colors.black38, fontSize: 18.0)))),
            SizedBox(height: 20.0),
            buildResumenDomicilios(),
            SizedBox(height: 20.0),
            Container(
                width: double.infinity,
                child: Text("Alguien necesita tu ayuda",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0)))),
            builDomicilios(),
          ],
        ),
      ),
    ));
  }

  Widget buildResumenDomicilios() {
    return ResumenDomicilio();
  }

  Widget builDomicilios() {
    return DomicilioListItem(widget.funcion);
  }
}
