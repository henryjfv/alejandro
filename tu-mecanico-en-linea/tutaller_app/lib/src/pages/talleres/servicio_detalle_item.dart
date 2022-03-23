import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/cartera.dart';
import 'package:tutaller_app/src/models/configuracion.dart';
import 'package:tutaller_app/src/models/servicio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/sistema.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicioDetalleItem extends StatefulWidget {
  final Servicio servicio;
  ServicioDetalleItem({this.servicio});

  @override
  _ServicioDetalleItemState createState() => _ServicioDetalleItemState();
}

class _ServicioDetalleItemState extends State<ServicioDetalleItem> {
  Servicio servicio;
  UserTaller usuario;
  double width = 0;
  TextEditingController _descripcionController;
  TextEditingController _valorController;
  Widget button;
  bool verCantidad = false;
  BuildContext mainContext;

  @override
  void initState() {
    servicio = widget.servicio;
    _descripcionController = new TextEditingController();
    _valorController = new TextEditingController();
    _descripcionController.text = servicio.descripcion;
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    usuario = Provider.of<UserTaller>(context) ??
        UserTaller(nombre: 'Nombre de taller', email: "email@email.com");
    width = MediaQuery.of(context).size.width;
    return Column(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
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
                      Text(servicio.nombreUsuario,
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
                Text("Problema: " + servicio.tipoDeServicio,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                        textStyle:
                            TextStyle(color: Colors.black38, fontSize: 12.0))),
                Text("Tel: " + servicio.telefonoUsuario,
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
                SizedBox(height: 20.0),
                buildOpciones()
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey[300], spreadRadius: 1),
              ],
            )),
        SizedBox(height: 20.0),
      ],
    );
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
                  Text("Codigo de tu cliente:",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black38, fontSize: 12.0))),
                  SizedBox(height: 5.0),
                  Text(servicio.codigo,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 40.0,
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
                    Text("Tu cliente programo la visita: ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.black38, fontSize: 12.0))),
                    SizedBox(height: 15.0),
                    Text(servicio.fecha + " " + servicio.hora,
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

    switch (servicio.estado) {
      case EstadoServicio.Creado:
        text = Text("Pendiente.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.redAccent[200], fontSize: 14.0)));
        break;
      case EstadoServicio.Tomado:
        text = Text("Tomado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.redAccent[200], fontSize: 14.0)));
        break;

      case EstadoServicio.Terminado:
        text = Text("Finalizado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.blueAccent[200], fontSize: 14.0)));
        break;

      case EstadoServicio.Cancelado:
        text = Text("Cancelado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.redAccent[200], fontSize: 14.0)));
        break;

      default:
        text = Text("Estado.",
            textAlign: TextAlign.end,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.redAccent[200], fontSize: 14.0)));
        break;
    }
    return text;
  }

  Widget buildOpciones() {
    switch (servicio.estado) {
      case EstadoServicio.Tomado:
        button = Center(
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
                  'Completar servicio',
                  style: GoogleFonts.openSans(
                      textStyle:
                          TextStyle(color: Colors.white, fontSize: 15.0)),
                ),
                onPressed: () async {
                  setState(() {
                    verCantidad = true;
                  });
                },
              )),
        );
        break;

      case EstadoServicio.Creado:
        button = Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (!verCantidad)
                  ? Center(
                      child: Wrap(
                        children: [
                          ButtonTheme(
                              height: 40.0,
                              minWidth: 120.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(color: Color(0xff1fc9d0))),
                                textColor: Colors.black,
                                color: Color(0xff1fc9d0),
                                child: Text(
                                  'Completar servicio',
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 15.0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    verCantidad = true;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: ButtonTheme(
                              height: 40.0,
                              minWidth: 120.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: BorderSide(
                                    color: Color(0xff25D366),
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Color(0xff25D366),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('WhatsApp'),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: FaIcon(FontAwesomeIcons.whatsapp),
                                    )
                                  ],
                                ),
                                onPressed: () => _openWhatsApp(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text("Valor del servicio",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold))),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  height: 40.0,
                                  width: 180.0,
                                  child: TextField(
                                    controller: _valorController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 20),
                                child: ButtonTheme(
                                  height: 40.0,
                                  minWidth: 120.0,
                                  child: Text("COP",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Wrap(
                              children: [
                                ButtonTheme(
                                  height: 40.0,
                                  minWidth: 150.0,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        side: BorderSide(
                                            color: Colors.red.shade800)),
                                    textColor: Colors.white,
                                    color: Colors.red.shade800,
                                    child: Text(
                                      'Cancelar',
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0)),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        verCantidad = false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                ButtonTheme(
                                    height: 40.0,
                                    minWidth: 150.0,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          side: BorderSide(
                                              color: Color(0xff1fc9d0))),
                                      textColor: Colors.black,
                                      color: Color(0xff1fc9d0),
                                      child: Text(
                                        'Finalizar',
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                      ),
                                      onPressed: () async {
                                        await finalizaServicio();
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        );
        break;

      default:
        button = Text("");
        break;
    }
    return button;
  }

  Future<void> finalizaServicio() async {
    if (_valorController.text.isEmpty) {
      SistemaTools().mostrarAlert(
          context, '¡Lo sentimos!', 'El campo valor no puede estar vacío');
    } else {
      double valor = double.parse(_valorController.text);
      Cartera cartera = new Cartera(
          cuenta: TipoCuenta.Servicio,
          estado: EstadoCartera.Pendiente,
          idServicioPrestado: servicio.codigo,
          valor: valor);
      servicio.estado = EstadoServicio.Terminado;
      servicio.valorServicio = valor;
      try {
        DatabaseService db = DatabaseService(uid: usuario.uid);
        await db.addCartera(cartera);
        usuario.cartera += valor;
        await db.updateTallerData(usuario);
        await db.updateEstadoServicio(servicio);
        db.notificarCliente(
            servicio.idUsuario,
            "Servicio finalizado",
            "Se ha finzaliado su servicio en el taller " +
                usuario.nombre.toUpperCase());
        if (context != null && this.mounted) {
          SistemaTools().mostrarAlert(
              mainContext, '¡Exito!', 'Servicio finalizado exitosamente.');
        }
      } catch (ex) {
        print(ex);
        if (context != null && this.mounted) {
          SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
              'No podemos finalizar el servicio, por favor vuelva a intentarlo');
        }
      }
    }
  }

  void _openWhatsApp() async {
    Configuracion config = await DatabaseService().configuracion;
    String url = 'whatsapp://send?phone=' +
        config.telefonoWhatsAppSoporte +
        '&text=' +
        config.mensajeWhatsappSoporte;
    await canLaunch(url)
        ? launch(url)
        : SistemaTools().mostrarAlert(
            context, '¡Lo sentimos!', 'No podemos abrir WhatsApp');
  }
}
