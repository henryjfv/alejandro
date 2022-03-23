import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/Pages/talleres/servicio_detalle_page.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/talleres/ayuda_taller.dart';
import 'package:tutaller_app/src/pages/talleres/perfil_page.dart';
import 'package:tutaller_app/src/pages/talleres/retiro_taller.dart';
import 'package:tutaller_app/src/pages/talleres/taller_home.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';

typedef callBackHijos = void Function();

class TallerMain extends StatefulWidget {
  @override
  _TallerMainState createState() => _TallerMainState();
}

class _TallerMainState extends State<TallerMain> {
  bool clickedCentreFAB =
      false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  UserApp usuario = UserApp();
  DatabaseService db;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserApp>(context);
    db = DatabaseService(uid: usuario.uid);

    return Scaffold(
      body: StreamProvider<UserTaller>.value(
          value: db.tallerData, child: buildPage()),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, //specify the location of the FAB
      floatingActionButton: buildBotonCentral(context),
      bottomNavigationBar: buildMenu(context),
    );
  }

  Widget buildMenu(BuildContext context) {
    return BottomAppBar(
      child: Container(
        margin: EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              //update the bottom app bar view each time an item is clicked
              onPressed: () {
                updateTabSelection(0, "Home");
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.home,
                //darken the icon if it is selected or else give it a different color
                color: selectedIndex == 0
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                updateTabSelection(1, "Ayuda");
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.help,
                color: selectedIndex == 1
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
            //to leave space in between the bottom app bar items and below the FAB
            SizedBox(
              width: 50.0,
            ),
            IconButton(
              onPressed: () {
                updateTabSelection(2, "Billetera");
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.attach_money,
                color: selectedIndex == 2
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                updateTabSelection(3, "Perfil");
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.person,
                color: selectedIndex == 3
                    ? Colors.blue.shade900
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
      //to add a space between the FAB and BottomAppBar
      shape: CircularNotchedRectangle(),
      //color of the BottomAppBar
      color: Colors.white,
    );
  }

  Widget buildBotonCentral(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          clickedCentreFAB =
              !clickedCentreFAB; //to update the animated container
          updateTabSelection(4, "Servicios");
        });
      },
      tooltip: "Mis servicios",
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Icon(Icons.time_to_leave),
      ),
      elevation: 4.0,
    );
  }

  //call this method on click of each bottom app bar item to update the screen
  void updateTabSelection(int index, String buttonText) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget buildPage() {
    switch (selectedIndex) {
      case 0:
        return TallerHome(actualizarDetalleServicio);
      case 1:
        return AyudaTaller();
      case 2:
        return RetiroTaller();
      case 3:
        return PerfilTaller();
      case 4:
        return ServicioDetalle();
      default:
        return Container();
    }
  }

  void actualizarDetalleServicio(callBackHijos funcionHijo) {
    setState(() {
      loading = true;
    });
    if (funcionHijo != null) {
      funcionHijo();
    }
    setState(() {
      loading = false;
      updateTabSelection(4, "Servicios");
    });
  }
}
