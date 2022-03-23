import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/utils/AppBarConfig.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/Decorations.dart';
import 'package:mecanico_app/src/utils/MapWidget.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  final UserTaller mTaller;
  MapPage({Key key, this.mTaller}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return _loadingMap(context);
  }

  Widget _loadingMap(BuildContext context) {
    return StreamProvider<List<UserTaller>>.value(
      value: DatabaseService().tallerData,
      child: Scaffold(
        body: Stack(
          children: [MapaWidget(taller: widget.mTaller), _toolbar(), _footer()],
        ),
      ),
    );
  }

//ESTE APPBAR SEA REALIZA DE ESA MANERA PARA QUE QUEDE EL MAPA ATRAS
  Widget _toolbar() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.10,
      width: double.infinity,
      decoration: decoracionCurvaGradientAppBar,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 25.0, top: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Taller más cercano',
              textAlign: TextAlign.center,
              style: CustomStyles().getStyleFont(Colors.white, 18.0),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 0.0),
              child: AccionesToolbar(context: context).getAcciones()[0],
            ),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff001558), Color(0xff0F6F94)],
              stops: [0.5, 1.5],
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70), topRight: Radius.circular(70))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 50.0),
          child: Text(
            'Elige seleccionando el punto en el mapa más cercano a tu ubicación',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
