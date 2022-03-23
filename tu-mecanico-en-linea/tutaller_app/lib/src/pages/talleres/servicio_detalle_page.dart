import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/Pages/shared/loading.dart';
import 'package:tutaller_app/src/Pages/talleres/servicio_detalle_list.dart';
import 'package:tutaller_app/src/models/servicio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/menuToolbar.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/sistema.dart';

class ServicioDetalle extends StatefulWidget {
  @override
  _ServicioDetalleState createState() => _ServicioDetalleState();
}

final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

class _ServicioDetalleState extends State<ServicioDetalle> {
  UserTaller usuario;
  double width = 0;
  bool loading = false;
  Stream<List<Servicio>> servicios;
  bool filtro = false;
  String codigoFiltro;
  bool cargando = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserTaller>(context) ??
        UserTaller(nombre: 'Nombre de taller', email: "email@email.com");
    width = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              buildContenido(),
              Container(
                key: UniqueKey(),
                color: Colors.grey[50],
                height: 190.0,
                child: Row(
                  children: [
                    SizedBox(width: 140.0),
                    Expanded(
                      child: Column(
                        key: UniqueKey(),
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
                          SizedBox(height: 0.0),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: Text("Servicios tomados",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold))),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0, 0),
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
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    filtro
                        ? IconButton(
                            alignment: Alignment.topRight,
                            icon: Icon(Icons.cancel_rounded),
                            tooltip: 'Cancelar',
                            color: Colors.grey.shade600,
                            onPressed: () {
                              setState(() {
                                cargando = true;
                              });
                              _timer =
                                  new Timer(Duration(milliseconds: 500), () {
                                setState(() {
                                  codigoFiltro = "";
                                  filtro = false;
                                  cargando = false;
                                  _timer.cancel();
                                });
                              });
                            },
                          )
                        : IconButton(
                            alignment: Alignment.topRight,
                            icon: Icon(Icons.search),
                            tooltip: 'Buscar código',
                            color: Colors.grey.shade600,
                            onPressed: () {
                              SistemaTools().inputDialog(
                                  context,
                                  'Buscar servicio',
                                  'Digite su código',
                                  filtrarServicios);
                            },
                          ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget buildContenido() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 160),
          child: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              alignment: Alignment.center,
              child: cargando
                  ? buildCargando()
                  : filtro
                      ? buildServicioFiltrado()
                      : buildListaServicios()),
        ),
      ),
    );
  }

  Widget buildListaServicios() {
    return StreamProvider<List<Servicio>>.value(
      value: DatabaseService(uid: usuario.uid).servicios2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[ServicioDetalleList(false)],
      ),
    );
  }

  Widget buildServicioFiltrado() {
    return StreamProvider<List<Servicio>>.value(
      value: DatabaseService(uid: usuario.uid).servicioByCodigo(codigoFiltro),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[ServicioDetalleList(true)],
      ),
    );
  }

  Widget buildCargando() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Text("Buscando servicio..."),
        ),
      ),
    );
  }

  void filtrarServicios(String codigo) {
    setState(() {
      cargando = true;
    });

    _timer = new Timer(Duration(milliseconds: 500), () {
      setState(() {
        codigoFiltro = codigo;
        filtro = true;
        cargando = false;
        _timer.cancel();
      });
    });
  }

  Future<Null> _refresh() async {
    setState(() {
      cargando = true;
    });

    _timer = new Timer(Duration(milliseconds: 500), () {
      setState(() {
        cargando = false;
        _timer.cancel();
      });
    });
    return null;
  }
}
