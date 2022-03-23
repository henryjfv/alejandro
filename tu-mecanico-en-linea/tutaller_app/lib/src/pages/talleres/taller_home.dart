import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/menuToolbar.dart';
import 'package:tutaller_app/src/pages/talleres/user-item-taller.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';

typedef callBackPrincipal = void Function(void Function());

class TallerHome extends StatefulWidget {
  TallerHome(this.funcion);
  callBackPrincipal funcion;

  @override
  _TallerHomeState createState() => _TallerHomeState();
}

class _TallerHomeState extends State<TallerHome> {
  bool clickedCentreFAB =
      false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";
  UserApp usuario = UserApp();
  DatabaseService db;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    UserTaller usuario = Provider.of<UserTaller>(context) ??
        UserTaller(
            nombre: 'Nombre de taller',
            email: "email@email.com",
            urlImagen: '');
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

          UserTallerItem(widget.funcion),
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
            image: DecorationImage(
              image: AssetImage('assets/img/portada-taller.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              //portada-taller.png
            ],
          )),
    );
  }
}
