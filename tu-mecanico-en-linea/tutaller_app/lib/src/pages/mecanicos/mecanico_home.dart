import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/mecanicos/usert-item-mecanico.dart';
import 'package:tutaller_app/src/pages/shared/menuToolbar.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';

typedef callBackPrincipal = void Function(void Function());

class MecanicoHome extends StatefulWidget {
  MecanicoHome(this.funcion);
  callBackPrincipal funcion;
  @override
  _MecanicoHomeState createState() => _MecanicoHomeState();
}

class _MecanicoHomeState extends State<MecanicoHome> {
  bool clickedCentreFAB =
      false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";
  DatabaseService db;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    UserMecanico usuario = Provider.of<UserMecanico>(context) ??
        UserMecanico(nombre: 'Nombre de mecanico', email: "email@email.com");
    //return buildFormulario();

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          buildBarraSuperior(width),

          MenuToolbar().menuToolbarDark(),

          Align(
            alignment: FractionalOffset.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 120.0),
              width: 160.0,
              height: 160.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:
                    (usuario.urlImagen != null && usuario.urlImagen.isNotEmpty)
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

          UserMecanicoItem(widget.funcion),
          //buildUsuarioInfo(context),
          //this is the code for the widget container that comes from behind the floating action button (FAB)
        ],
      ),
    );
  }

  Widget buildBarraSuperior(double width) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Container(
          height: 200,
          width: width,
          decoration: BoxDecoration(
            color: Color(0xff203387),
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[],
          )),
    );
  }
}
