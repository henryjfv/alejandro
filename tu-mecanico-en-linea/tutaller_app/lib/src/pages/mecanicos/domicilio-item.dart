import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:enum_to_string/enum_to_string.dart';

typedef callBackPrincipal = void Function(void Function());

class DomicilioItem extends StatefulWidget {
  final Domicilio domicilio;
  callBackPrincipal funcion;
  DomicilioItem({this.domicilio, this.funcion});

  @override
  _DomicilioItemState createState() => _DomicilioItemState();
}

class _DomicilioItemState extends State<DomicilioItem> {
  Domicilio domicilio;
  double width = 0;
  UserMecanico usuario;

  @override
  void initState() {
    domicilio = widget.domicilio;
  }

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserMecanico>(context) ??
        UserMecanico(nombre: 'Nombre de mecanico', email: "email@email.com");

    width = MediaQuery.of(context).size.width;
    return Column(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            key: UniqueKey(),
            width: double.infinity,
            alignment: Alignment.topLeft, // Alignment(-1.0, -1.0),
            padding: const EdgeInsets.only(left: 35.0, top: 10.0, bottom: 10.0),
            margin: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(domicilio.nombreUsuario,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black38, fontSize: 18.0))),
                        Text(
                          domicilio.ubicacionActual,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Text(EnumToString.convertToString(domicilio.estado),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black38, fontSize: 12.0))),
                      FlatButton(
                          onPressed: () async {
                            await tomarServicio(domicilio);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Text("Tomar servicio >",
                              textAlign: TextAlign.end,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.blueAccent[200],
                                      fontSize: 16.0))))
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey[600], spreadRadius: 1),
              ],
            )),
        SizedBox(height: 20.0),
      ],
    );
  }

  Future<void> tomarServicio(final Domicilio domicilio) async {
    widget.funcion(() async {
      var db = DatabaseService();
      domicilio.idMecanico = usuario.uid;
      domicilio.nombreMecanico = usuario.nombre;
      domicilio.urlImagenMecanico = usuario.urlImagen;
      if (domicilio.domicilioPagado) {
        domicilio.estado = EstadoDomicilio.Pagado;
      } else {
        domicilio.estado = EstadoDomicilio.Tomado;
      }
      await db.updateDomicilioData(domicilio);
      await db.notificarCliente(domicilio.idUsuario, "Servicio tomado",
          usuario.nombre.toUpperCase() + " ha tomado su servicio.");
    });
  }
}
