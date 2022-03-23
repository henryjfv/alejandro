import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/loading_screen.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/firebase_auth.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:mecanico_app/src/utils/utils.dart';
import 'package:provider/provider.dart';

class FormularioPerfil extends StatefulWidget {
  @override
  _FormularioPerfilState createState() => _FormularioPerfilState();
}

class _FormularioPerfilState extends State<FormularioPerfil> {
  TextEditingController _nombreControler;
  TextEditingController _emailCotroller;
  TextEditingController _telefonoController;
  TextEditingController _recuperarContrller;
  UserData usuario;

  final picker = ImagePicker();
  File _file;
  String urlImage = '';
  bool load = true;
  bool loadProgress = false;

  @override
  void initState() {
    super.initState();
    _nombreControler = TextEditingController(text: '');
    _emailCotroller = TextEditingController(text: '');
    _telefonoController = TextEditingController(text: '');
    _recuperarContrller = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    var usuario = Provider.of<UserData>(context);
    if (load && usuario != null) {
      _cargarDatos();
      load = false;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    _seleccionarFoto();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    overflow: Overflow.clip,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: urlImage.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  image: urlImage,
                                  placeholder: 'images/placeholder_avatar.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                )
                              : _file != null
                                  ? Image.file(
                                      _file,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'images/placeholder_avatar.png',
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    )),
                      Positioned(
                        top: 80,
                        right: 0,
                        child: FaIcon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                enabled: false,
                controller: _emailCotroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(color: Colors.grey, fontSize: 15.0)),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _nombreControler,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Nombre',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(color: Colors.white, fontSize: 15.0)),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _telefonoController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Teléfono',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(color: Colors.white, fontSize: 15.0)),
              ),
              SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    child: Text('Restablecer contraseña',
                        style: CustomStyles().getStyleFont(Colors.white, 18.0)),
                    onPressed: () {
                      mostrarResetearPass(context);
                    }),
              ),
              SizedBox(
                height: 20.0,
              ),
              ButtonTheme(
                height: 50.0,
                minWidth: 250.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: colorTitleText,
                    ),
                  ),
                  textColor: Colors.white,
                  color: colorTitleText,
                  child: Text(
                    'Guardar',
                    style: CustomStyles().getStyleFont(Colors.white, 12.0),
                  ),
                  onPressed: () {
                    if (_nombreControler.text.isNotEmpty ||
                        _telefonoController.text.isNotEmpty) {
                      setState(() {
                        loadProgress = true;
                      });
                      UserData usuarioTemp = usuario;
                      usuarioTemp.nombres = _nombreControler.text.trim();
                      usuarioTemp.telefono = _telefonoController.text.trim();
                      _guardarPerfil(usuarioTemp);
                    } else {
                      SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
                          'Ningún campo puede estar vacío.');
                    }
                  },
                ),
              )
            ],
          ),
        ),
        loadProgress ? LoadingScreen() : Container(),
      ],
    );
  }

  void _cargarDatos() {
    print("========= METODO CARGADAR DATOS ==========");
    usuario = Provider.of<UserData>(context) ?? UserData();

    _nombreControler = TextEditingController(text: usuario.nombres);

    _emailCotroller = TextEditingController(text: usuario.email);

    _telefonoController = TextEditingController(text: usuario.telefono);
    urlImage = usuario.urlImage;
  }

  void mostrarResetearPass(BuildContext context) {
    _recuperarContrller = TextEditingController(text: _emailCotroller.text);
    bool envio = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Restablecer Contraseña",
              style: CustomStyles().getStyleFontWithFontWeight(
                  Colors.black, 18.0, FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Ingresa tu correo electrónico abajo y se te enviará la información necesaria para restablecerla.",
                  style: CustomStyles().getStyleFont(Colors.black, 15.0),
                ),
                TextField(
                  controller: _recuperarContrller,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico *',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: CustomStyles().getStyleFont(Colors.black, 15.0),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    if (_recuperarContrller.text.isEmpty) {
                      SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
                          'El correo y la contraseña no deben estar vacíos');
                      return;
                    } else {
                      AuthProvider()
                          .sendResetPassword(_recuperarContrller.text.trim());
                      envio = true;
                      Navigator.of(context).pop();
                    }
                  }),
            ],
          );
        }).then((value) {
      if (envio) {
        SistemaTools().mostrarAlert(
            context,
            '¡Correo enviado!',
            'Por favor verifica tu bandeja de entrada, ' +
                'Se ha enviado un email al correo ingresado para ' +
                'recuperar tu contraseña.');
      }
    });
  }

  void _seleccionarFoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        urlImage = '';
        _file = File(pickedFile.path);
      });
    } else {
      print('No hay imagen seleccionada');
    }
  }

  void _guardarPerfil(UserData usuario) async {
    final _storage = FirebaseStorage.instance;
    if (_file != null) {
      String fileName = usuario.email + '/imagen_' + usuario.email;
      var result = await _storage.ref().child(fileName).putFile(_file);
      String imgUrl = (await result.ref.getDownloadURL()).toString();
      setState(() {
        urlImage = imgUrl;
      });
    } else {
      print('imagen nula');
    }
    await DatabaseService()
        .updatePerfilUserData(usuario.uid, usuario.nombres, usuario.telefono,
            urlImage ?? usuario.urlImage)
        .then((res) {
      SistemaTools().mostrarAlert(context, '¡Exitoso!', 'Datos actualizados.');

      setState(() {
        loadProgress = false;
      });
    });
  }
}
