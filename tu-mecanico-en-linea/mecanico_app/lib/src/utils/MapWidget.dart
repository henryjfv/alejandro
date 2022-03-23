import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mecanico_app/src/models/servicio.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';
import 'package:mecanico_app/src/pages/taller_page.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:mecanico_app/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class MapaWidget extends StatefulWidget {
  UserTaller taller;
  MapaWidget({Key key, this.taller}) : super(key: key);

  @override
  _MapaWidgetState createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controllerMap;
  final LatLng _center = const LatLng(10.994728, -74.806098);
  final Set<Marker> marcadores = Set();

  LocationData currentLocation;
  StreamSubscription<LocationData> locationSubscription;
  Location location = new Location();
  String error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLocation = null;
    getUserLocation();
    locationSubscription =
        location.onLocationChanged.listen((LocationData result) {
      currentLocation = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          _googleMap(context),
          Padding(
            padding: const EdgeInsets.only(bottom: 120, right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  getUserLocation();
                },
                child: Icon(Icons.location_on),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: FloatingActionButton.extended(
          //     label: Text('Mi Ubicacion'),
          //     icon: Icon(Icons.location_on),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _googleMap(BuildContext context) {
    final talleres = Provider.of<List<UserTaller>>(context) ?? [];
    setState(() {
      for (var item in talleres) {
        marcadores.add(Marker(
            markerId: MarkerId(item.uid.toString()),
            position: LatLng(item.latitud, item.longitud),
            infoWindow: InfoWindow(title: item.nombre),
            onTap: () {
              _modalBottomSheet(context, item);
            }));
      }
    });

    return GoogleMap(
      markers: Set.from(marcadores),
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controllerMap = controller;
    _controller.complete(controller);
    getLocation(controller).then((location) {
      if (location != null &&
          currentLocation != null &&
          currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng position =
            new LatLng(currentLocation.latitude, currentLocation.longitude);
        /* marcadores.add(marker); */
        Future.delayed(Duration(seconds: 1), () async {
          GoogleMapController controller = await _controller.future;

          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: position,
                zoom: 17.0,
              ),
            ),
          );
        });
      }
    });
  }

  Future<LatLng> getLocation(GoogleMapController controller) async {
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidth / 2;
    double middleY = screenHeight / 2;

    ScreenCoordinate screenCoordinate =
        ScreenCoordinate(x: middleX.round(), y: middleY.round());

    LatLng middlePoint = await controller.getLatLng(screenCoordinate);

    return middlePoint;
  }

  // Future<Uint8List> _myMarkerToBitmap(String label) async {
  //   ui.PictureRecorder recorder = ui.PictureRecorder();
  //   final canvas = Canvas(recorder);
  //   MyMarker myMarker = MyMarker(label);
  //   myMarker.paint(canvas, Size(300, 70));
  //   final ui.Image image = await recorder.endRecording().toImage(300, 70);
  //   final ByteData byData =
  //       await image.toByteData(format: ui.ImageByteFormat.png);
  //   return byData.buffer.asUint8List();
  // }

  void _modalBottomSheet(context, taller) {
    DatabaseService db = new DatabaseService();
    String id = FirebaseAuth.instance.currentUser.uid.toString();
    Future<List<Servicio>> servicios = db.getServicioUsuario(id);
    Servicio servicio = null;
    servicios.then((values) {
      for (Servicio item in values) {
        if (item.idTaller == taller.uid &&
            item.estado == EstadoServicio.Creado) {
          servicio = item;
          return;
        }
      }
    });
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return FutureBuilder(
              future: servicios,
              builder: (context, dataFuture) {
                if (dataFuture.hasData && dataFuture.data != null) {
                  var value = dataFuture.data;

                  try {
                    var tallerEcontrado = value.any(
                      (element) =>
                          element != null &&
                          (element.idTaller == taller.uid &&
                              (element.estado == EstadoServicio.Creado ||
                                  element.estado == EstadoServicio.Tomado)),
                    );

                    if (tallerEcontrado) {
                      return Container(
                        height: 300,
                        alignment: Alignment.center,
                        decoration: decoracionBottomSheet,
                        child: _layoutServicioActivo(servicio),
                      );
                    } else {
                      return Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: decoracionBottomSheet,
                        child: _layoutAgendarCita(taller),
                      );
                    }
                  } catch (e) {
                    // print(e);
                    return Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: decoracionBottomSheet,
                      child: _layoutAgendarCita(taller),
                    );
                  }
                } else {
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: decoracionBottomSheet,
                    child: _layoutAgendarCita(taller),
                  );
                }
              });
          //child: _layoutServicioActivo(taller.titulo));
        });
  }

  Widget _layoutAgendarCita(taller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(taller.nombre,
            style: CustomStyles().getStyleFont(Colors.black, 20.0)),
        SizedBox(
          height: 20.0,
        ),
        ButtonTheme(
          height: 50.0,
          minWidth: 250.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: colorBackground),
            ),
            textColor: Colors.white,
            color: colorBackground,
            child: Text(
              'Asignar una cita',
              style: CustomStyles().getStyleFont(Colors.white, 15.0),
            ),
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => TallerPage(mTaller: taller),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _layoutServicioActivo(Servicio servicio) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Tu código es',
                    style: CustomStyles().getStyleFont(Colors.blueGrey, 15.0),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    servicio.codigo,
                    style: CustomStyles().getStyleFontWithFontWeight(
                        Colors.teal, 25.0, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage.assetNetwork(
                  image: servicio.urlImagenTaller,
                  placeholder: 'images/placeholder_avatar.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'Tu cita quedo para: ' + servicio.fecha + " " + servicio.hora,
                  style: CustomStyles().getStyleFontWithFontWeight(
                      Colors.teal, 15.0, FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Text(
                      'Taller',
                      style: CustomStyles().getStyleFont(Colors.teal, 15.0),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      servicio.nombreTaller,
                      style: CustomStyles().getStyleFontWithFontWeight(
                          Colors.teal, 15.0, FontWeight.bold),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'En Ciudad / Municipio: ' + servicio.ciudad,
                  style: CustomStyles().getStyleFontWithFontWeight(
                      Colors.teal, 15.0, FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Text(
                      'Tu valor',
                      style: CustomStyles().getStyleFont(Colors.teal, 15.0),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Se te informará en el taller',
                      style: CustomStyles().getStyleFontWithFontWeight(
                          Colors.teal, 15.0, FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dirección: ' + servicio.direccion,
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.teal, 15.0, FontWeight.bold),
                textAlign: TextAlign.left,
              ))
        ],
      ),
    );
  }

  // void _currentLocation() async {
  //   final GoogleMapController controller = await _controller.future;
  //   LocationData currentLocation;
  //   var location = new Location();
  //   try {
  //     currentLocation = await location.getLocation();
  //   } on Exception {
  //     currentLocation = null;
  //   }

  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //       bearing: 0,
  //       target: LatLng(currentLocation.latitude, currentLocation.longitude),
  //       zoom: 17.0,
  //     ),
  //   ));
  // }

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();

    bool serviceEnabled;
    LocationPermission permission;

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
      Navigator.pop(context);
    } else {
      Singleton().currentLocation = myLocation;
      UserTaller tallertemp = widget.taller;
      if (this.mounted &&
          myLocation != null &&
          myLocation.latitude != null &&
          myLocation.longitude != null) {
        setState(() {
          currentLocation = myLocation;
          if (tallertemp != null) {
            _controllerMap.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: new LatLng(tallertemp.latitud, tallertemp.longitud),
                  zoom: 17.0,
                ),
              ),
            );
          } else {
            _controllerMap.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: new LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                  zoom: 17.0,
                ),
              ),
            );
          }
        });
      }
    }
    //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  }
}
