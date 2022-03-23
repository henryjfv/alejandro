import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/servicio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';
import 'package:tutaller_app/src/pages/talleres/resumen-servicio.dart';
import 'package:tutaller_app/src/pages/talleres/servicio-list-item.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';

typedef callBackPrincipal = void Function(void Function());

class UserTallerItem extends StatefulWidget {
  UserTallerItem(this.funcion);
  callBackPrincipal funcion;

  @override
  _UserTallerItemState createState() => _UserTallerItemState();
}

class _UserTallerItemState extends State<UserTallerItem> {
  UserTaller usuario;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserTaller>(context) ??
        UserTaller(nombre: 'Nombre de taller', email: "email@email.com");
    width = MediaQuery.of(context).size.width;

    return Container(
        key: UniqueKey(),
        child: Container(
          child: StreamProvider<List<Servicio>>.value(
            value: DatabaseService(uid: usuario.uid).servicios2,
            child: Column(
              key: UniqueKey(),
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 300.0),
                Center(
                    child: Text(usuario.nombre,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black, fontSize: 18.0)))),
                Center(
                    child: Text(usuario.email,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black38, fontSize: 18.0)))),
                SizedBox(height: 20.0),
                buildResumenServicios(),
                SizedBox(height: 20.0),
                Container(
                    width: double.infinity,
                    child: Text("Alguien necesita tu ayuda",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black, fontSize: 20.0)))),
                builServiciosPrestados(),
              ],
            ),
          ),
        ));
  }

  Widget buildResumenServicios() {
    return ResumenServicio();
  }

  Widget builServiciosPrestados() {
    return ServicioListItem(widget.funcion);
  }
}
