import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/Pages/mecanicos/domicilio-detalle-list.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';
import 'package:tutaller_app/src/pages/shared/loading.dart';
import 'package:tutaller_app/src/pages/shared/menuToolbar.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';

class DomicilioDetalle extends StatefulWidget {
  @override
  _DomicilioDetalleState createState() => _DomicilioDetalleState();
}

class _DomicilioDetalleState extends State<DomicilioDetalle> {
  UserMecanico usuario;
  double width = 0;
  bool loading = false;
  bool filtro = false;
  String estado;
  bool cargando = false;
  Timer _timer;
  int paginaFiltro = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserMecanico>(context) ??
        UserMecanico(nombre: 'Nombre de mecanico', email: "email@email.com");
    width = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Stack(
              children: <Widget>[
                cargando
                    ? buildCargando()
                    : filtro
                        ? buildContenidoFiltrado()
                        : buildContenido(),
                Container(
                  color: Colors.grey[50],
                  height: 190.0,
                  child: Row(
                    children: [
                      SizedBox(width: 140.0),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 80.0),
                            Center(
                                child: Text(usuario.nombre,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0)))),
                            Center(
                                child: Text(usuario.email,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 14.0)))),
                            SizedBox(height: 20.0),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 32),
                                child: Text("Servicios Tomados",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(top: 40.0, left: 20.0),
                    width: 120.0,
                    height: 120.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: usuario.urlImagen.isNotEmpty
                          ? FadeInImage.assetNetwork(
                              image: usuario.urlImagen,
                              placeholder: 'assets/img/placeholder_avatar.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/img/placeholder_avatar.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                MenuToolbar().menuToolbarLight(),
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: PopupMenuButton<int>(
                      icon: Icon(
                        Icons.filter_alt,
                        color: Colors.grey.shade500,
                        size: 28.0,
                      ),
                      onSelected: (value) => _seleccionFiltro(value),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text('Mostrar todos'),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text('Esperando pago'),
                        ),
                        const PopupMenuItem<int>(
                          value: 2,
                          child: Text('Pagados'),
                        ),
                        const PopupMenuItem<int>(
                          value: 3,
                          child: Text('Terminados'),
                        ),
                        const PopupMenuItem<int>(
                          value: 4,
                          child: Text('Cancelados'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  _seleccionFiltro(int value) async {
    setState(() {
      paginaFiltro = value;
      cargando = true;
    });

    _timer = new Timer(Duration(milliseconds: 500), () {
      setState(() {
        switch (value) {
          case 0:
            estado = "";
            filtro = false;
            break;
          case 1:
            estado = EnumToString.convertToString(EstadoDomicilio.Tomado);
            filtro = true;
            break;
          case 2:
            estado = EnumToString.convertToString(EstadoDomicilio.Pagado);
            filtro = true;
            break;
          case 3:
            estado = EnumToString.convertToString(EstadoDomicilio.Terminado);
            filtro = true;
            break;
          case 4:
            estado = EnumToString.convertToString(EstadoDomicilio.Cancelado);
            filtro = true;
            break;
        }
        cargando = false;
        _timer.cancel();
      });
    });
  }

  Widget buildContenido() {
    return Padding(
      padding: const EdgeInsets.only(top: 160),
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: StreamProvider<List<Domicilio>>.value(
              value: DatabaseService(uid: usuario.uid).domicilios,
              child: Column(
                key: UniqueKey(),
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[DomicilioDetalleList()],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget buildContenidoFiltrado() {
    return Padding(
      padding: const EdgeInsets.only(top: 160),
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: StreamProvider<List<Domicilio>>.value(
              value: DatabaseService(uid: usuario.uid)
                  .getDomiciliosByEstado(usuario.uid, estado),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[DomicilioDetalleList()],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget buildCargando() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Text("Cargando domicilios..."),
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    await _seleccionFiltro(paginaFiltro);
    return null;
  }
}
