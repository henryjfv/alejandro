import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/Pages/talleres/servicio_detalle_item.dart';
import 'package:tutaller_app/src/models/servicio.dart';

class ServicioDetalleList extends StatefulWidget {
  ServicioDetalleList(this.busqueda);
  bool busqueda;
  @override
  _ServicioDetalleListState createState() => _ServicioDetalleListState();
}

class _ServicioDetalleListState extends State<ServicioDetalleList> {
  double width = 0;
  bool busqueda = false;

  @override
  Widget build(BuildContext context) {
    this.busqueda = widget.busqueda;
    final servicios = Provider.of<List<Servicio>>(context) ?? [];
    double height = MediaQuery.of(context).size.height;

    return (servicios.length > 0)
        ? Container(
            key: UniqueKey(),
            child: SizedBox(
              height: height - 228.0,
              child: new ListView.builder(
                key: UniqueKey(),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemCount: servicios.length,
                itemBuilder: (context, index) {
                  return ServicioDetalleItem(servicio: servicios[index]);
                },
              ),
            ),
          )
        : buildMensajeVacio();
  }

  Widget buildMensajeVacio() {
    if (!busqueda)
      return Padding(
          key: UniqueKey(),
          padding: const EdgeInsets.only(top: 35.0),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Center(
                      child: Text("Por el momento no tienes ninguna cita",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Color(0xff1fc9d0),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.normal)))),
                ),
                Row(children: <Widget>[
                  SizedBox(width: 20.0),
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                  )),
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                  )),
                  SizedBox(width: 20.0),
                ]),
              ],
            ),
          ));
    else
      return Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Center(
                      child: Text("Servicio no encontrado",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Color(0xff1fc9d0),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.normal)))),
                ),
                Row(children: <Widget>[
                  SizedBox(width: 20.0),
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                  )),
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                  )),
                  SizedBox(width: 20.0),
                ]),
              ],
            ),
          ));
  }
}
