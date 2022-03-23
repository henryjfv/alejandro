import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tutaller_app/src/Pages/shared/loading.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/mecanicos/ayuda_mecanico.dart';
import 'package:tutaller_app/src/pages/mecanicos/perfil_page.dart';
import 'package:tutaller_app/src/pages/mecanicos/retiro_mecanico.dart';
import 'package:tutaller_app/src/pages/shared/singleTone.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/sistema.dart';
import 'domicilio-detalle-page.dart';
import 'mecanico_home.dart';

typedef callBackHijos = void Function();

class MecanicoMain extends StatefulWidget {
  @override
  _MecanicoMainState createState() => _MecanicoMainState();
}

class _MecanicoMainState extends State<MecanicoMain> {
  bool clickedCentreFAB =
      false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  UserApp usuario = UserApp();
  DatabaseService db;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    getUserLocation();
    usuario = Provider.of<UserApp>(context);
    db = DatabaseService(uid: usuario.uid);

    return Scaffold(
        body: StreamProvider<UserMecanico>.value(
            value: db.mecanicoData, child: loading ? Loading() : buildPage()),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .centerDocked, //specify the location of the FAB
        floatingActionButton: buildBotonCentral(context),
        bottomNavigationBar: buildMenu(context));
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
          updateTabSelection(4, "Domicilios");
          //clickedCentreFAB = !clickedCentreFAB; //to update the animated container
        });
      },
      tooltip: "Mis domicilios",
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
        return MecanicoHome(actualizarDetalleDomicilio);
      case 1:
        return AyudaMecanico();
      case 2:
        return RetiroMecanico();
      case 3:
        return PerfilMecanico();
      case 4:
        return DomicilioDetalle();
      default:
        return Container();
    }
  }

  void actualizarDetalleDomicilio(callBackHijos funcionHijo) {
    setState(() {
      loading = true;
    });
    loading = true;
    if (funcionHijo != null) {
      funcionHijo();
    }
    setState(() {
      loading = false;
      updateTabSelection(4, "Domicilios");
    });
  }

  getUserLocation() async {
    //call this async method from whereever you need
    bool serviceEnabled;
    LocationPermission permission;
    String error;
    LocationData myLocation;
    Location location = new Location();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      error =
          'Los servicios de ubicación están desactivados. por favor activelos';
      print(error);
      myLocation = null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      error =
          'permiso GPS denegado: habilítelo desde la configuración de la aplicación.';
      print(error);
      myLocation = null;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        error =
            'Se deniegan los permisos de ubicación. por favor conceda permiso.';
        print(error);
        myLocation = null;
      }
    }

    var configuracion = await DatabaseService().configuracion;
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'por favor conceda permiso.';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'permiso GPS denegado: habilítelo desde la configuración de la aplicación.';
        print(error);
      }
      myLocation = null;
    }

    if (error != "" && error != null) {
      SistemaTools().mostrarAlert(context, "Error", error);
    } else {
      Singleton().currentLocation = myLocation;
      Singleton().distanciaBusqueda = configuracion.distanciaBusqueda;
    }
    //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  }
}
