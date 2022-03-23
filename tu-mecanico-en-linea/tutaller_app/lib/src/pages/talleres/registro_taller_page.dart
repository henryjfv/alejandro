import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/loading.dart';
import 'package:tutaller_app/src/pages/shared/singleTone.dart';
import 'package:tutaller_app/src/pages/talleres/map_register.dart';
import 'package:tutaller_app/src/providers/push_notifications_provider.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/firebase_auth.dart';
import 'package:tutaller_app/src/utils/sistema.dart';
import 'package:tutaller_app/src/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistroTallerPage extends StatefulWidget {
  @override
  _RegistroTallerPageState createState() => _RegistroTallerPageState();
}

class _RegistroTallerPageState extends State<RegistroTallerPage> {
  TextEditingController _nombreController;
  TextEditingController _propietarioController;
  TextEditingController _serviciosController;
  TextEditingController _marcasController;
  TextEditingController _telefonoController;
  TextEditingController _direccionController;
  TextEditingController _nitController;
  TextEditingController _numeroCuentaController;
  TextEditingController _bancoController;
  TextEditingController _emailCotroller;
  TextEditingController _passwordController;
  bool loading = false;
  String selectedMunicipio;
  List<String> options = <String>[];
  bool _obscureText = true;
  bool _terminosYCondiciones = false;
  double width = 0;
  String urlContrato = '';

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: '');
    _propietarioController = TextEditingController(text: '');
    _serviciosController = TextEditingController(text: '');
    _marcasController = TextEditingController(text: '');
    _telefonoController = TextEditingController(text: '');
    _direccionController = TextEditingController(text: '');
    _nitController = TextEditingController(text: '');
    _numeroCuentaController = TextEditingController(text: '');
    _bancoController = TextEditingController(text: '');
    _emailCotroller = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    DatabaseService().configuracion.then((value) {
      if (options.isEmpty) {
        setState(() {
          value.ciudades.forEach((element) {
            options.add(element.toString());
          });
          urlContrato = value.urlContratoTaller;
        });
      }
    });

    return loading
        ? Loading()
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  //color: Color(0xff18203d),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/registro-fondo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              'assets/img/logo-blanco.png',
                              height: 80.0,
                            ),
                          ),
                          Text('¡Te damos la bienvenida!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 28.0))),
                          SizedBox(height: 20.0),
                          Text('Nos alegra que quieras ser parte del registro',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 18.0))),
                          SizedBox(height: 20.0),
                          TextField(
                            controller: _nombreController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Nombre Completo *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _propietarioController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Propietario *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _telefonoController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Celular *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _direccionController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              hintText: 'Dirección *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          (selectedMunicipio == null)
                              ? Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text('Ciudad donde opera*',
                                        style: CustomStyles()
                                            .getStyleFontWithFontWeight(
                                                Colors.white,
                                                12.0,
                                                FontWeight.normal),
                                        textAlign: TextAlign.left),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: DropdownButton(
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
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
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList();
                              },
                              items: options.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value != '' ? value : ''),
                                );
                              }).toList(),
                            ),
                          ),
                          TextField(
                            controller: _nitController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'NIT *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _serviciosController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Servicios *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _marcasController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Marcas *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _numeroCuentaController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Numero de cuenta *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _bancoController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Banco *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _emailCotroller,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Correo electrónico *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              hintText: 'Contraseña *',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: this._obscureText
                                      ? Colors.white
                                      : Colors.blueGrey,
                                ),
                                onPressed: () {
                                  _toggle();
                                },
                              ),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                              verticalDirection: VerticalDirection.up,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Checkbox(
                                  value: this._terminosYCondiciones,
                                  onChanged: (bool value) {
                                    setState(() {
                                      this._terminosYCondiciones = value;
                                    });
                                  },
                                ),
                                const SizedBox(width: 3.0),
                                SizedBox(
                                  width: width - 130,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0)),
                                            text:
                                                "Por la presente declaro que soy mayor de " +
                                                    "edad, he leido y acepto "),
                                        TextSpan(
                                          text: ' EL CONTRATO DE TALLERES ',
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 13.0)),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = urlContrato;
                                              await canLaunch(url)
                                                  ? launch(url)
                                                  : SistemaTools().mostrarAlert(
                                                      context,
                                                      '¡Lo sentimos!',
                                                      'No podemos abrir el documento.');
                                            },
                                        ),
                                        TextSpan(
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0)),
                                          text: "Y acepto ",
                                        ),
                                        TextSpan(
                                          text: ' TERMINOS Y CONDICIONES ',
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 13.0)),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url =
                                                  'https://github.com/flutter/gallery/';
                                              print("Clicked ${url}!");
                                            },
                                        ),
                                        TextSpan(
                                          text: "para ser " +
                                              "prestador de servicios de mecánica automotriz " +
                                              "y que cumplo con los requisitidos exigidos de " +
                                              "TU MECANICO EN LÍNEA S.A.S y la normatividad " +
                                              "vigente colombiana.",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                          const SizedBox(height: 20.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () async {
                                    await obtenerDatosGoogle();
                                  },
                                  child: Text(
                                      'Registrate con una cuenta Google',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0))),
                                )
                              ]),
                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ButtonTheme(
                                height: 40.0,
                                minWidth: 120.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side:
                                          BorderSide(color: Color(0xff0f6f94))),
                                  textColor: Colors.white,
                                  color: Color(0xff0f6f94),
                                  child: Text(
                                    'Ya tengo una cuenta',
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0)),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              ButtonTheme(
                                height: 40.0,
                                minWidth: 120.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side:
                                          BorderSide(color: Color(0xff1fc9d0))),
                                  textColor: Colors.white,
                                  color: Color(0xff1fc9d0),
                                  child: Text(
                                    'Registrate',
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0)),
                                  ),
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    await registrarTaller();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Text('Recibe tu mecánico a domicilio',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 15.0))),
                        ]),
                  ),
                ),
              ],
            ),
          );
  }

  bool validaciones() {
    if (_passwordController.text.length < 6) {
      SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
          'Tu contraseña debe tener al menos 6 caracteres');
      return false;
    }
    if (!this._terminosYCondiciones) {
      SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
          'Debes aceptar los terminos y condiciones para continuar.');
      return false;
    }
    return true;
  }

  Future<void> registrarTaller() async {
    if (_nombreController.text.isEmpty ||
        _propietarioController.text.isEmpty ||
        _serviciosController.text.isEmpty ||
        _marcasController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _direccionController.text.isEmpty ||
        _isEmpty(selectedMunicipio) ||
        _nitController.text.isEmpty ||
        _numeroCuentaController.text.isEmpty ||
        _bancoController.text.isEmpty ||
        _emailCotroller.text.isEmpty ||
        _passwordController.text.isEmpty) {
      SistemaTools().mostrarAlert(
          context, '¡Lo sentimos!', 'Ningún campo puede estar vacío');
      setState(() => loading = false);
    } else {
      if (validaciones()) {
        UserTaller taller = UserTaller(
            email: _emailCotroller.text.trim(),
            password: _passwordController.text.trim(),
            nombre: _nombreController.text.trim(),
            propietario: _propietarioController.text.trim(),
            nit: _nitController.text.trim(),
            celular: int.parse(_telefonoController.text.trim()),
            direccion: _direccionController.text.trim(),
            ciudad: selectedMunicipio,
            marcas: _marcasController.text.trim(),
            servicios: _serviciosController.text.trim(),
            tieneHerramientas: true,
            cuentaBancaria: _numeroCuentaController.text.trim(),
            banco: _bancoController.text.trim(),
            cartera: 0);

        UserTaller tallerMap = await Navigator.push(
            context,
            new CupertinoPageRoute(
              builder: (BuildContext context) =>
                  new TallerRegisterMapPage(taller: taller),
              fullscreenDialog: true,
            ));

        if (tallerMap != null &&
            tallerMap.latitud != null &&
            tallerMap.longitud != null) {
          taller.latitud = tallerMap.latitud;
          taller.longitud = tallerMap.longitud;
        }

        if (taller.latitud != null && taller.longitud != null) {
          UserApp res = await AuthProvider().registerTaller(taller);
          if (res != null) {
            await registrarToken();
            Navigator.pop(context);
          } else {
            SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
                'No podemos hacer el registro, por favor vuelva a intentarlo');
            print(res);
            setState(() => loading = false);
          }
        }
      } else {
        setState(() => loading = false);
      }
    }
  }

  Future<void> registrarToken() {
    var notificador = Singleton().notificador;
    if (notificador == null) {
      notificador = new PushNotificationProvider();
      Singleton().notificador = notificador;
    }
    notificador.initNotifications();
    return null;
  }

  Future<void> obtenerDatosGoogle() async {
    await AuthProvider().getGoogleInformation().then((value) => setState(() {
          _nombreController.text = value.nombre;
          _emailCotroller.text = value.email;
        }));
  }

  _isEmpty(String value) {
    if (value == null || value.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
