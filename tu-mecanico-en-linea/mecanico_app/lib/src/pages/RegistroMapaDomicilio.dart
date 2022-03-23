import 'dart:async';
import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:mecanico_app/src/utils/styles.dart';

class RegistroMapaDomicilioPage extends StatefulWidget {
  final Domicilio domicilio;
  RegistroMapaDomicilioPage({Key key, this.domicilio}) : super(key: key);

  @override
  __RegistroMapaDomicilioState createState() => __RegistroMapaDomicilioState();
}

class __RegistroMapaDomicilioState extends State<RegistroMapaDomicilioPage> {
  @override
  void initState() {
    domicilio = widget.domicilio;
    domicilio.latitud = null;
    domicilio.longitud = null;
    geoMethods = GeoMethods(
      googleApiKey: 'AIzaSyD4zbqzFr6Ne5A2BPwxZgoepOeBkVW7P30',
      language: 'es',
      countryCode: 'co',
      country: 'Colombia',
      city: domicilio.ciudadMunicipio,
    );
  }

  Domicilio domicilio;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  final LatLng _center = const LatLng(5.2744033, -74.1250783);
  Coords initialCoords = new Coords(5.2744033, -74.1250783);
  Marker updatedMarker;
  String text = "";
  GeoMethods geoMethods;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = domicilio.ubicacionActual;

    var addressDialogBuilder = AddressDialogBuilder(
      //color: Colors.white,
      backgroundColor: Colors.white,
      hintText: "Escribe una dirección",
      noResultsText: "Dirección no encontrada",
      cancelText: "Cancelar",
      continueText: "Continuar",
      useButtons: true,
    );

    var addressSearchBuilder = AddressSearchBuilder.deft(
      geoMethods: geoMethods,
      controller: textController,
      builder: addressDialogBuilder,
      onDone: buscarDireccion,
    );

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 11.0),
              myLocationEnabled: true,
              onCameraMove: (CameraPosition position) {
                if (position != null) {
                  if (_markers != null && _markers.length > 0) {
                    MarkerId markerId = MarkerId(_markerIdVal());
                    Marker marker = _markers[markerId];
                    updatedMarker = marker.copyWith(
                      positionParam: position.target,
                    );

                    setState(() {
                      if (_markers != null) {
                        _markers[markerId] = updatedMarker;
                      }
                    });
                  }
                }
              },
            ),
          ),
          Container(
            height: size.height * .15,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.indigo[900],
                  Colors.indigo[800],
                  Colors.indigo[600]
                ], begin: Alignment.topRight),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
          ),
          Container(
            child: new Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 35.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.indigo,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: AddressSearchBuilder(
                          geoMethods: geoMethods,
                          controller: textController,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<List<Address>> snapshot, {
                            TextEditingController controller,
                            Future<void> Function() searchAddress,
                            Future<Address> Function(Address address)
                                getGeometry,
                          }) {
                            return Column(
                              children: [
                                TextField(
                                    readOnly: true,
                                    controller: textController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        fillColor: Colors.white,
                                        hintText: "Dirección",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                    style: CustomStyles()
                                        .getStyleFont(Colors.black, 17.0),
                                    onTap: () =>
                                        null /* showDialog(
                                    context: context,
                                    builder: (context) {
                                      return addressSearchBuilder;
                                    },
                                  ), */
                                    ),
                              ],
                            );
                          },
                        ),
                      )),
                      MaterialButton(
                          onPressed: () {
                            domicilio.latitud = updatedMarker.position.latitude;
                            domicilio.longitud =
                                updatedMarker.position.longitude;
                            Navigator.pop(context, domicilio);
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Icon(
                            Icons.save,
                            size: 24,
                          ),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder())
                    ],
                  ),
                  new Container(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    mapController = controller;
    displayPrediction(
            domicilio.ubicacionActual + ", " + domicilio.ciudadMunicipio)
        .then((location) {
      if (location != null) {
        MarkerId markerId = MarkerId(_markerIdVal());
        LatLng position = location;
        Marker marker =
            Marker(markerId: markerId, position: position, draggable: false);

        setState(() {
          if (_markers != null) {
            _markers[markerId] = marker;
          }
        });

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

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  Future<LatLng> displayPrediction(String direccion) async {
    var addresses = await locationFromAddress(direccion);
    if (addresses != null && addresses.length > 0) {
      var first = addresses.first;
      if (first != null) {
        LatLng target = LatLng(first.latitude, first.longitude);
        return target;
      }
    }
    return null;
  }

  void buscarDireccion(Address address) {
    if (address != null &&
        address.coords != null &&
        address.coords.latitude != null &&
        address.coords.longitude != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      Marker marker = _markers[markerId];
      LatLng target = LatLng(address.coords.latitude, address.coords.longitude);
      if (address.coords.latitude != null) {
        updatedMarker = marker.copyWith(
          positionParam: target,
        );
        setState(() {
          _markers[markerId] = updatedMarker;
          domicilio.ubicacionActual = textController.text;
        });
        mapController.animateCamera(CameraUpdate.newLatLng(target));
      }
    }
    //Navigator.of(context).pop();
  }
}
