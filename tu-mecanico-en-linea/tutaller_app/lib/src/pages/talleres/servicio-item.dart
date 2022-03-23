import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutaller_app/src/models/servicio.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';

typedef callBackPrincipal = void Function(void Function());

class ServicioItem extends StatefulWidget {
  final callBackPrincipal funcion;
  final Servicio servicio;
  ServicioItem({this.servicio, this.funcion});

  @override
  _ServicioItemState createState() => _ServicioItemState();
}

class _ServicioItemState extends State<ServicioItem> {
  Servicio servicio;
  double width = 0;

  @override
  void initState() {
    servicio = widget.servicio;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            key: UniqueKey(),
            width: double.infinity,
            alignment: Alignment.topLeft, // Alignment(-1.0, -1.0),
            padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              key: UniqueKey(),
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 200.0),
                Text(servicio.nombreUsuario,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                        textStyle:
                            TextStyle(color: Colors.black38, fontSize: 18.0))),
                SizedBox(height: 5.0),
                Text("Problema: " + servicio.tipoDeServicio,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                        textStyle:
                            TextStyle(color: Colors.black38, fontSize: 16.0))),

                Text(
                  "Tel: +57 " + servicio.telefonoUsuario,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(color: Colors.black38, fontSize: 16.0),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      tomarServicio(servicio);
                    },
                    child: Text(
                      "Tomar servicio >",
                      textAlign: TextAlign.end,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.blueAccent[200], fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey[300], spreadRadius: 1),
              ],
            )),
        SizedBox(height: 20.0),
      ],
    );
  }

  Future<void> tomarServicio(final Servicio domicilio) async {
    widget.funcion(() async {
      domicilio.estado = EstadoServicio.Tomado;
      //await DatabaseService().upd(domicilio);
    });
  }
}
