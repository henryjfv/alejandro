import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/pages/DomicilioPage.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/utils/Colors.dart';
import 'package:mecanico_app/src/utils/Decorations.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mecanico_app/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:url_launcher/url_launcher.dart';

import 'RegistroMapaDomicilio.dart';

class MecanicoPage extends StatefulWidget {
  MecanicoPage({Key key}) : super(key: key);

  @override
  _MecanicoPageState createState() => _MecanicoPageState();
}

class _MecanicoPageState extends State<MecanicoPage> {
  TextEditingController _ubicacionCotroller;
  TextEditingController _barrioController;
  TextEditingController _marcaCotroller;
  TextEditingController _modeloController;
  TextEditingController _kilometrajeCotroller;
  TextEditingController _descripcionController;
  String selectedMunicipio;
  bool pantallaDomicilio = false;
  Domicilio domicilio = Domicilio();
  List<String> options = <String>[];
  String valorPago = "50.000";

  @override
  void initState() {
    _ubicacionCotroller = TextEditingController(text: '');
    _barrioController = TextEditingController(text: '');
    _marcaCotroller = TextEditingController(text: '');
    _modeloController = TextEditingController(text: '');
    _kilometrajeCotroller = TextEditingController(text: '');
    _descripcionController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String idUser = FirebaseAuth.instance.currentUser.uid.toString();
    DatabaseService().configuracion.then((value) {
      if (options.isEmpty) {
        setState(() {
          value.ciudades.forEach((element) {
            options.add(element.toString());
          });
        });
      }
    });
    DatabaseService(uid: idUser).domicilio.then((value) {
      if (value != null) {
        // print(value.marcaCarro);
        domicilio = value;
        setState(() {
          pantallaDomicilio = true;
        });
      }
    });
    DatabaseService().configuracion.then((config) {
      if (config.valorDomicilioMecanicos != null &&
          config.valorDomicilioMecanicos != "") {
        double valor = double.tryParse(config.valorDomicilioMecanicos);
        if (this.mounted) {
          this.setState(() {
            valorPago = expresionRegular(valor);
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        actions: AccionesToolbar(context: context).getAcciones(),
      ),
      body: (pantallaDomicilio
          ? buildFormularioDomicilio()
          : buildFormularioPrincipal()),
    );
  }

  Widget buildFormularioPrincipal() {
    return SingleChildScrollView(
        child: Column(
      children: [
        _padreFormulario(context),
        SizedBox(
          height: 30.0,
        ),
        _accionFormulario(context),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Recuerda que cualquier duda puedes escribirnos a tumecanicoenlinnea2020@gmail.com',
          style: CustomStyles().getStyleFont(Colors.teal, 12.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    ));
  }

  Widget buildFormularioDomicilio() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamProvider<Domicilio>.value(
                value: DatabaseService()
                    .getDomicilio(domicilio.idUsuario, domicilio.fecha),
                child: DomicilioPage()),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Recuerda que cualquier duda puedes escribirnos a tumecanicoenlinnea2020@gmail.com',
              style: CustomStyles().getStyleFont(Colors.teal, 12.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _accionFormulario(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tu valor',
                        style: CustomStyles().getStyleFont(
                          Colors.grey,
                          10.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'El valor del mecánico + ' + valorPago + ' cop',
                        style: CustomStyles().getStyleFontWithFontWeight(
                            Colors.black, 10.0, FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Expanded(
          flex: 5,
          child: FlatButton(
            child: Text('Solicitar servicio',
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.blue, 15.0, FontWeight.bold)),
            onPressed: () async {
              if (_noEstaVacio(selectedMunicipio) &&
                  _noEstaVacio(_ubicacionCotroller.text.trim()) &&
                  _noEstaVacio(_barrioController.text.trim()) &&
                  _noEstaVacio(_marcaCotroller.text.trim()) &&
                  _noEstaVacio(_modeloController.text.trim()) &&
                  _noEstaVacio(_kilometrajeCotroller.text.trim())) {
                domicilio = Domicilio();
                domicilio.idUsuario =
                    FirebaseAuth.instance.currentUser.uid.toString();
                domicilio.ciudadMunicipio = selectedMunicipio;
                domicilio.ubicacionActual = _ubicacionCotroller.text.trim();
                domicilio.barrio = _barrioController.text.trim();
                domicilio.marcaCarro = _marcaCotroller.text.trim();
                domicilio.modelo = _modeloController.text.trim();
                domicilio.kilometraje = _kilometrajeCotroller.text.trim();
                domicilio.descripcion = _descripcionController.text.trim();
                domicilio.nombreUsuario = user.nombres;
                domicilio.telefonoUsuario = user.telefono.toString();
                domicilio.estado = EstadoDomicilio.Creado;
                domicilio.fecha = DateTime.now().toString();
                domicilio.referenciaPago = 0;

                Domicilio domicilioMap = await Navigator.push(
                    context,
                    new CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          new RegistroMapaDomicilioPage(domicilio: domicilio),
                      fullscreenDialog: true,
                    ));
                if (domicilioMap != null &&
                    domicilioMap.latitud != null &&
                    domicilioMap.longitud != null &&
                    domicilioMap.latitud != 0 &&
                    domicilioMap.longitud != 0 &&
                    domicilioMap.longitud != 0.0 &&
                    domicilioMap.latitud != 0.0) {
                  domicilio.latitud = domicilioMap.latitud;
                  domicilio.longitud = domicilioMap.longitud;
                }

                if (domicilio != null &&
                    domicilio.latitud != null &&
                    domicilio.longitud != null &&
                    domicilio.latitud != 0 &&
                    domicilio.longitud != 0 &&
                    domicilio.longitud != 0.0 &&
                    domicilio.latitud != 0.0) {
                  // print(domicilio.idUsuario);
                  await DatabaseService(uid: domicilio.idUsuario)
                      .addDomicilioData(domicilio);
                  // print(domicilio);
                  setState(() {
                    pantallaDomicilio = true;
                  });
                }
              } else {
                SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
                    'No podemos hacer el registro. Los campos marcados con (*) son obligatorios');
              }
            },
          ),
        )
      ],
    );
  }

  Widget _padreFormulario(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorBackground,
            colorAccent,
          ],
          stops: [0.1, 1.5],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        ),
      ),
      child: _formularioBuscandoMecanico(),

      //layoutCodigo()
    );
  }

  Widget _formularioBuscandoMecanico() {
    return Column(
      children: [
        Text(
          'Danos tu ubicación actual',
          style: CustomStyles()
              .getStyleFontWithFontWeight(Colors.white, 19.0, FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
          padding: EdgeInsets.fromLTRB(90, 20, 20, 20),
          decoration: decoracionTitulos,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Estamos buscando',
                  style: CustomStyles().getStyleFont(Colors.grey, 10.0),
                  textAlign: TextAlign.left,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'A tu mecánico más cercano ...',
                  style: CustomStyles().getStyleFontWithFontWeight(
                      colorTitleText, 15.0, FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Ciudad *',
              style: CustomStyles().getStyleFontWithFontWeight(
                  Colors.white, 15.0, FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        DropdownButton(
          style: new TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          ),
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              selectedMunicipio = value;
            });
          },
          value: selectedMunicipio,
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Ubicación actual *',
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.white, 15.0, FontWeight.bold),
                textAlign: TextAlign.left),
          ),
        ),
        TextField(
          controller: _ubicacionCotroller,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Calle 123#45-67',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: CustomStyles().getStyleFont(Colors.white, 18.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Barrio *',
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.white, 15.0, FontWeight.bold),
                textAlign: TextAlign.left),
          ),
        ),
        TextField(
          controller: _barrioController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Recreo',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: CustomStyles().getStyleFont(Colors.white, 18.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Marca del carro *',
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.white, 15.0, FontWeight.bold),
                textAlign: TextAlign.left),
          ),
        ),
        TextField(
          controller: _marcaCotroller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Mazda',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: CustomStyles().getStyleFont(Colors.white, 18.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Modelo *',
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.white, 15.0, FontWeight.bold),
                textAlign: TextAlign.left),
          ),
        ),
        TextField(
          controller: _modeloController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: '2002',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: CustomStyles().getStyleFont(Colors.white, 18.0),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Kilometraje *',
                style: CustomStyles().getStyleFontWithFontWeight(
                    Colors.white, 15.0, FontWeight.bold),
                textAlign: TextAlign.left),
          ),
        ),
        TextField(
          controller: _kilometrajeCotroller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: '107000',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: CustomStyles().getStyleFont(Colors.white, 18.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Si quieres puedes ser más específico sobre lo que le pasa a tu carro',
          style: CustomStyles().getStyleFont(Colors.white, 15.0),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.indigo,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: TextField(
            controller: _descripcionController,
            textInputAction: TextInputAction.done,
            maxLines: 8,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
            width: double.infinity,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _formularioMecanicoEnCamino() {
    return SafeArea(
      child: Column(
        children: [
          Text(
            'Tu mecánico ya está en camino',
            style: CustomStyles().getStyleFontWithFontWeight(
                Colors.white, 19.0, FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Mecánico',
                            style:
                                CustomStyles().getStyleFont(Colors.grey, 10.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Julian Armando Calles',
                            style: CustomStyles().getStyleFontWithFontWeight(
                                Colors.green, 15.0, FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'images/no-arranca-grande.png',
                            height: 200.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Container(
                              color: Colors.grey,
                              height: 1.0,
                              width: double.infinity,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Tu valor',
                                            style: CustomStyles().getStyleFont(
                                              Colors.grey,
                                              10.0,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'El valor del mecánico + ' +
                                                valorPago +
                                                ' cop',
                                            style: CustomStyles()
                                                .getStyleFontWithFontWeight(
                                                    Colors.black,
                                                    10.0,
                                                    FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: ButtonTheme(
                                          height: 50.0,
                                          minWidth: 250.0,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: BorderSide(
                                                color: Color(0xff25D366),
                                              ),
                                            ),
                                            textColor: Colors.white,
                                            color: Color(0xff25D366),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'WhatsApp',
                                                  style: CustomStyles()
                                                      .getStyleFont(
                                                          Colors.white, 12.0),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: FaIcon(FontAwesomeIcons
                                                      .whatsapp),
                                                )
                                              ],
                                            ),
                                            onPressed: () => _openWhatsApp(),
                                          ),
                                        )),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlineButton(
                                        color: Colors.yellow,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        child: Text(
                                          'Siguiente',
                                          style: CustomStyles()
                                              .getStyleFontWithFontWeight(
                                                  Colors.black,
                                                  12.0,
                                                  FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _noEstaVacio(String value) {
    if (value != null && !value.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void _openWhatsApp() async {
    Configuracion config = await DatabaseService().configuracion;
    String url = 'whatsapp://send?phone=' +
        config.telefonoWhatsAppSoporte +
        '&text=' +
        config.mensajeWhatsappSoporte;
    await canLaunch(url)
        ? launch(url)
        : SistemaTools().mostrarAlert(
            context, '¡Lo sentimos!', 'No podemos abrir WhatsApp');
  }

  String expresionRegular(double numero) {
    NumberFormat f = new NumberFormat("#,###.0#", "es_US");
    String result = f.format(numero);
    return result;
  }
}
