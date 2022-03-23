import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/sistema.dart';
import 'package:tutaller_app/src/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DomicilioDetalleItem extends StatefulWidget {
  final Domicilio domicilio;
  DomicilioDetalleItem({this.domicilio});

  @override
  _DomicilioDetalleItemState createState() => _DomicilioDetalleItemState();
}

class _DomicilioDetalleItemState extends State<DomicilioDetalleItem> {
  Domicilio domicilio;
  double width = 0;
  TextEditingController _descripcionController;
  UserMecanico usuario;

  @override
  void initState() {
    domicilio = widget.domicilio;
    _descripcionController = new TextEditingController();
    _descripcionController.text = domicilio.descripcion;
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
        (domicilio.estado != EstadoDomicilio.Cancelado)
            ? getTargetaNormal()
            : getTargetaCancelada(),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget getTargetaNormal() {
    return Container(
        width: double.infinity,
        alignment: Alignment.topLeft, // Alignment(-1.0, -1.0),
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                verticalDirection: VerticalDirection.up,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(domicilio.nombreUsuario,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black38, fontSize: 16.0))),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20),
                      child: buildEstadoDomicilio(),
                    ),
                  )
                ]),
            SizedBox(height: 10.0),
            Text("Problema:     Mi carro no prende",
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(color: Colors.black38, fontSize: 12.0))),
            Text("Tel: " + domicilio.telefonoUsuario,
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(color: Colors.black38, fontSize: 12.0))),
            SizedBox(height: 10.0),
            Text("Especificaciones del cliente",
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold))),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(right: 90),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[100],
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: TextField(
                    controller: _descripcionController,
                    maxLines: 8,
                    enabled: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 20.0, right: 20.0),
                      fillColor: Colors.white,
                    )),
              ),
            ),
            SizedBox(height: 10.0),
            buildInformacionUbicacion(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10.0, 20.0, 10.0),
              child: buildOpciones(),
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey[300], spreadRadius: 1),
          ],
        ));
  }

  Widget getTargetaCancelada() {
    return Container(
        width: double.infinity,
        alignment: Alignment.topLeft, // Alignment(-1.0, -1.0),
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                verticalDirection: VerticalDirection.up,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(domicilio.nombreUsuario,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black38, fontSize: 16.0))),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20),
                        child: buildEstadoDomicilio()),
                  )
                ]),
            SizedBox(height: 10.0),
            Text("Problema:     Mi carro no prende",
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(color: Colors.black38, fontSize: 12.0))),
            Text("Ubicación: " + domicilio.ubicacionActual,
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(color: Colors.black38, fontSize: 12.0))),
            SizedBox(height: 10.0),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey[300], spreadRadius: 1),
          ],
        ));
  }

  Widget buildInformacionUbicacion() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 250,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Text("Ubicaciòn del cliente:",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black38, fontSize: 14.0))),
                  SizedBox(height: 15.0),
                  Text(domicilio.ubicacionActual,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)))
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Text("Ciudad o Municipio: ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black38, fontSize: 14.0))),
                    SizedBox(height: 15.0),
                    Text(domicilio.ciudadMunicipio,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black38, fontSize: 16.0)))
                  ])),
        ],
      ),
    );
  }

  Widget buildEstadoDomicilio() {
    Widget text;

    switch (domicilio.estado) {
      case EstadoDomicilio.Tomado:
        text = Text("Esperando pago.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.redAccent[200], fontSize: 14.0)));
        break;

      case EstadoDomicilio.Pagado:
        text = Text("Pago realizado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.blueAccent[200], fontSize: 14.0)));
        break;

      case EstadoDomicilio.Terminado:
        text = Text("Finalizado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.blueAccent[200], fontSize: 14.0)));
        break;

      case EstadoDomicilio.Cancelado:
        text = Text("Cancelado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.redAccent[200], fontSize: 14.0)));
        break;

      default:
        text = Text("Creado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.redAccent[200], fontSize: 14.0)));
        break;
    }
    return text;
  }

  Widget buildOpciones() {
    Widget button;

    switch (domicilio.estado) {
      case EstadoDomicilio.Tomado:
        button = Center(
          child: ButtonTheme(
              height: 40.0,
              minWidth: 120.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.grey[300])),
                textColor: Colors.black,
                color: Colors.grey,
                child: Text(
                  'Aùn no han pagado',
                  style: GoogleFonts.openSans(
                      textStyle:
                          TextStyle(color: Colors.white, fontSize: 15.0)),
                ),
                onPressed: () async {},
              )),
        );
        break;

      case EstadoDomicilio.Pagado:
        button = Center(
          child: Container(
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                ButtonTheme(
                    minWidth: 150.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Color(0xff1fc9d0))),
                      textColor: Colors.black,
                      color: Color(0xff1fc9d0),
                      child: Text(
                        'Como llegar',
                        style: GoogleFonts.openSans(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 12.0)),
                      ),
                      onPressed: () async {
                        launchMap(domicilio.ubicacionActual +
                            " , " +
                            domicilio.ciudadMunicipio);
                      },
                    )),
                SizedBox(width: 20.0),
                /* Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ButtonTheme(
                        height: 40.0,
                        minWidth: 120.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Color(0xff1fc9d0))),
                          textColor: Colors.black,
                          color: Color(0xff1fc9d0),
                          child: Text(
                            'Chatea con el cliente',
                            style: GoogleFonts.openSans(
                                textStyle:
                                    TextStyle(color: Colors.white, fontSize: 14.0)),
                          ),
                          onPressed: () async {},
                        )),
                  ), */
                ButtonTheme(
                    minWidth: 150.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Color(0xff0fba201))),
                      textColor: Colors.black,
                      color: Color(0xff0fba201),
                      child: Text(
                        'Cancelar servicio',
                        style: GoogleFonts.openSans(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 12.0)),
                      ),
                      onPressed: () {
                        mostrarAlerta(context);
                      },
                    )),
              ],
            ),
          ),
        );
        break;

      default:
        button = Text("");
        break;
    }
    return button;
  }

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

  Future<void> cancelarDomicilio() async {
    try {
      DatabaseService db = DatabaseService(uid: usuario.uid);
      domicilio.estado = EstadoDomicilio.Creado;
      await db.updateEstadoDomicilio(domicilio);
      await db.notificarCliente(domicilio.idUsuario, "Servicio cancelado",
          usuario.nombre.toUpperCase() + " ha cancelado su servicio.");
      SistemaTools()
          .mostrarAlert(context, '¡Exito!', 'Servicio cancelado exitosamente.');
    } catch (Exception) {
      SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
          'No podemos cancelar el servicio, por favor vuelva a intentarlo.');
    }
  }

  void mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "¿Estás seguro que deseas cancelar el servicio?",
              style: CustomStyles().getStyleFontWithFontWeight(
                  Colors.black, 18.0, FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    'SI CANCELAR',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    await cancelarDomicilio();
                  }),
              FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}
