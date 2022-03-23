import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/models/servicio.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/ServiciosTomadosPage.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';
import 'package:mecanico_app/src/pages/taller_page.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:mecanico_app/src/utils/utils.dart';
import 'package:provider/provider.dart';

import 'map_page.dart';

class RegistroServicio extends StatefulWidget {
  final UserTaller taller;
  RegistroServicio({Key key, this.taller}) : super(key: key);

  @override
  _RegistroServicioState createState() => _RegistroServicioState();
}

class _RegistroServicioState extends State<RegistroServicio> {
  TextEditingController _dateController;
  TextEditingController _descripcionController;
  TextEditingController _timeController;
  String _selectedCity;
  String codigo = '0';
  String idTaller = '';
  /* List<City> _cities = City.getCities(); */
  String tallerNombre = '';
  bool flagLayout = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  UserTaller selectedTaller;

  void initState() {
    /* _dropdownMenuItems = buildDropDownMenuItems(_cities); */
    _descripcionController = TextEditingController(text: '');
    _dateController = TextEditingController(text: '');
    _timeController = TextEditingController(text: '');
    tallerNombre = widget.taller.nombre.toString();
    idTaller = widget.taller.uid.toString();
    selectedTaller = widget.taller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* String idUser = FirebaseAuth.instance.currentUser.uid.toString(); */
    _dateController = TextEditingController(
        text: selectedDate.toLocal().toString().split(' ')[0]);
    _timeController = TextEditingController(text: selectedTime.format(context));

    return Scaffold(
        appBar: _appbar(context),
        body: flagLayout ? _layoutCodigo() : _padrePrincial());
  }

  Widget _appbar(context) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorBackground,
      actions: AccionesToolbar(context: context).getAcciones(),
    );
  }

  Widget _padrePrincial() {
    final user = Provider.of<UserData>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          _fondo(context),
          SizedBox(
            height: 10.0,
          ),
          ButtonTheme(
            height: 50.0,
            minWidth: 250.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Color(0xff1fc9d0))),
              textColor: Colors.white,
              color: Color(0xff1fc9d0),
              child: Text(
                'Agéndate',
                style: CustomStyles().getStyleFont(Colors.white, 12.0),
              ),
              onPressed: () async {
                var form = this;
                try {
                  Servicio servicio = Servicio();
                  servicio.idUsuario =
                      FirebaseAuth.instance.currentUser.uid.toString();
                  DatabaseService db = DatabaseService(uid: servicio.idUsuario);
                  await db.userData.first.then((user) async {
                    await _generarNumeroRandom().then((consecutivo) async {
                      servicio.codigo = consecutivo.toString();
                      servicio.nombreTaller = tallerNombre;
                      servicio.idTaller = idTaller;
                      servicio.ciudad = _selectedCity;
                      servicio.fecha = _dateController.text;
                      servicio.hora = _timeController.text;
                      servicio.estado = EstadoServicio.Creado;
                      servicio.descripcion = _descripcionController.text;
                      codigo = servicio.codigo;
                      servicio.nombreUsuario = user.nombres;
                      servicio.telefonoUsuario = user.telefono.toString();
                      servicio.tipoDeServicio = Singleton().tipoEvento;
                      servicio.confirmado = false;
                      servicio.urlImagenTaller = selectedTaller.urlImagen;
                      servicio.valorServicio = 0;
                      servicio.direccion = selectedTaller.direccion;
                      db.addServicioData(servicio);
                      form.setState(() {
                        flagLayout = true;
                      });
                      new DatabaseService().notificarTaller(
                          servicio.idTaller,
                          "Nuevo servicio",
                          "Fecha : " +
                              servicio.fecha +
                              ", Hora: " +
                              servicio.hora +
                              ", Cliente: " +
                              servicio.nombreUsuario);
                    });
                  });
                } catch (ex) {
                  SistemaTools()
                      .mostrarAlert(form.context, "Error", ex.toString());
                }
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Recuerda que cualquier duda puedes escribirnos a tumecanicoenlinnea2020@gmail.com',
            style: CustomStyles().getStyleFont(Colors.teal, 12.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _fondo(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(top: 20.0),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorBackground,
                  colorAccent,
                ],
                stops: [0.5, 1.5],
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(70))),
          child: _princiapLayout() //layoutCodigo()

          ),
    );
  }

  List<String> options = <String>['Barranquilla', 'Bogotá', 'Medellín'];

  Widget _princiapLayout() {
    return Column(
      children: [
        Text(
          'Agéndate con tu taller mas cercano',
          style: CustomStyles()
              .getStyleFontWithFontWeight(Colors.white, 19.0, FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
          padding: EdgeInsets.fromLTRB(90, 20, 20, 20),
          decoration: decoracionTitulos,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Taller',
                  style: GoogleFonts.openSans(
                      textStyle:
                          TextStyle(color: Colors.black, fontSize: 12.0))),
              SizedBox(
                height: 5.0,
              ),
              Text(tallerNombre,
                  style: CustomStyles().getStyleFontWithFontWeight(
                      Colors.teal, 15.0, FontWeight.bold))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('El horario de atención es de 7:00 am hasta 6:00 pm',
                style: CustomStyles().getStyleFont(Colors.white, 15.0),
                textAlign: TextAlign.start),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Que día piensas ir al taller',
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.white, 15.0, FontWeight.bold),
                textAlign: TextAlign.start),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: TextField(
                  readOnly: true,
                  controller: _dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: CustomStyles().getStyleFont(Colors.white, 15.0),
                  onTap: () {
                    _selectedDate(context);
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: TextField(
                  readOnly: true,
                  controller: _timeController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: CustomStyles().getStyleFont(Colors.white, 15.0),
                  onTap: () {
                    _selectedTime(context);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Ciudad',
                    style: CustomStyles().getStyleFontWithFontWeight(
                        Colors.white, 15.0, FontWeight.bold),
                    textAlign: TextAlign.left),
              ),
              DropdownButton(
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
                value: _selectedCity,
                selectedItemBuilder: (BuildContext context) {
                  return options.map((String value) {
                    return Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value != '' ? value : ''),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                  'Si quieres puedes ser más específico sobre lo que le pasa a tu carro',
                  style: CustomStyles().getStyleFont(Colors.white, 15.0)),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
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
                child: TextField(
                    controller: _descripcionController,
                    maxLines: 8,
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
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Container(
            color: Colors.white,
            height: 1.0,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget _layoutCodigo() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff001558), Color(0xff0F6F94)],
                    stops: [0.5, 1.5],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70))),
              child: Column(children: [
                Card(
                  margin: EdgeInsets.all(30.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Taller',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black, fontSize: 12.0))),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(tallerNombre,
                            style: CustomStyles().getStyleFontWithFontWeight(
                                Colors.teal, 15.0, FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Card(
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tu código es:',
                          style: GoogleFonts.openSans(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          codigo,
                          style: CustomStyles().getStyleFontWithFontWeight(
                              Colors.blueGrey, 50.0, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('Tu cita quedo para: ${_dateController.text}',
                            style: CustomStyles().getStyleFontWithFontWeight(
                                Colors.teal, 15.0, FontWeight.bold)),
                        Text('En la ciudad: ${_selectedCity}',
                            style: CustomStyles().getStyleFontWithFontWeight(
                                Colors.teal, 15.0, FontWeight.bold)),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            color: Colors.blueGrey[100],
                            height: 1.0,
                            width: double.infinity,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Tu valor',
                                        style: CustomStyles().getStyleFont(
                                          Colors.teal,
                                          12.0,
                                        ),
                                        textAlign: TextAlign.left),
                                  ),
                                  Text('Se te informará en el taller',
                                      style: CustomStyles()
                                          .getStyleFontWithFontWeight(
                                              Colors.teal,
                                              15.0,
                                              FontWeight.bold),
                                      textAlign: TextAlign.left),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FlatButton(
                                      child: Text('Ubicación del taller',
                                          style: CustomStyles()
                                              .getStyleFontWithFontWeight(
                                                  Colors.blue,
                                                  15.0,
                                                  FontWeight.bold)),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => MapPage(
                                                mTaller: selectedTaller),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FlatButton(
                                      child: Text('Siguiente',
                                          style: CustomStyles()
                                              .getStyleFontWithFontWeight(
                                                  Colors.blue,
                                                  15.0,
                                                  FontWeight.bold)),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                ServiciosTomados(),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ]),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text(
                  'Recuerda que con el código puedes tomar tu diagnóstico ¡GRATIS!',
                  style: CustomStyles().getStyleFontWithFontWeight(
                      Colors.black, 20.0, FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Recuerda que cualquier duda puedes escribirnos a tumecanicoenlinnea2020@gmail.com',
                  style: CustomStyles().getStyleFont(Colors.teal, 12.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<int> _generarNumeroRandom() async {
    Configuracion config = await DatabaseService().configuracion;
    config.consecutivo = config.consecutivo + 1;
    DatabaseService().updateConsecutivoConfig(config);
    return config.consecutivo;
  }

/*   onChangeDropdownItem(City selectedCity) {
    setState(() {
      _selectedCity = selectedCity;
    });
  } */

/*   List<DropdownMenuItem<City>> buildDropDownMenuItems(List cities) {
    List<DropdownMenuItem<City>> items = List();
    for (City city in cities) {
      items.add(DropdownMenuItem(
        value: city,
        child: Text(city.name,
            style: CustomStyles().getStyleFont(Colors.white, 15.0)),
      ));
    }
    return items;
  }
 */
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate.subtract(Duration(days: 30)),
        lastDate: DateTime(selectedDate.year + 1));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<Null> _selectedTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _dateController.text = selectedTime.format(context);
      });
    }
  }
}
