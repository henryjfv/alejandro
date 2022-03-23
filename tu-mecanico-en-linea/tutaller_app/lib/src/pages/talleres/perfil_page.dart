import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/loading.dart';
import 'package:tutaller_app/src/pages/shared/menuToolbar.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/sistema.dart';
import 'package:tutaller_app/src/utils/styles.dart';

import 'map_register.dart';

class PerfilTaller extends StatefulWidget {
  @override
  _PerfilTallerItemState createState() => _PerfilTallerItemState();
}

class _PerfilTallerItemState extends State<PerfilTaller> {
  UserTaller usuario;
  double width = 0;

  TextEditingController _nombreController;
  TextEditingController _propietarioController;
  TextEditingController _serviciosController;
  TextEditingController _marcasController;
  TextEditingController _telefonoController;
  TextEditingController _direccionController;
  TextEditingController _nitController;
  TextEditingController _numeroCuentaController;
  TextEditingController _bancoController;
  String selectedMunicipio = "";
  bool loading = false;
  List<String> options = <String>[];

  final picker = ImagePicker();
  File _file;
  String urlImage = '';
  bool load = true;

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
  }

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserTaller>(context) ??
        UserTaller(
            nombre: 'Nombre de taller',
            email: "email@email.com",
            urlImagen: '');
    width = MediaQuery.of(context).size.width;

    DatabaseService().configuracion.then((value) {
      if (options.isEmpty) {
        setState(() {
          value.ciudades.forEach((element) {
            options.add(element);
          });
        });
      }
    });

    if (load && usuario != null) {
      loadInformation();
      load = false;
    }
    return loading
        ? Loading()
        : Stack(
            children: <Widget>[
              buildFormulario(),
              Container(
                color: Colors.grey[50],
                height: 160.0,
                child: Row(
                  children: [
                    SizedBox(width: 140.0),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 80.0),
                          Center(
                              child: Text(usuario.nombre,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0)))),
                          Expanded(
                            child: Text(usuario.email,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14.0))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: FractionalOffset.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0, 0),
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
                                    placeholder:
                                        'assets/img/placeholder_avatar.png',
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
                                        'assets/img/placeholder_avatar.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )),
                        Positioned(
                          top: 80,
                          right: 0,
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.grey,
                            size: 30.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              MenuToolbar().menuToolbarLight(),
            ],
          );
  }

  Widget buildFormulario() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 180.0),
        child: Column(children: [
          Text(
            'Información del perfil',
            textAlign: TextAlign.center,
            style: CustomStyles().getStyleFont(Colors.black, 26.0),
          ),
          Row(children: <Widget>[
            SizedBox(width: 20.0),
            Expanded(child: Divider()),
            Expanded(child: Divider()),
            SizedBox(width: 20.0),
          ]),
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        hintText: 'Nombre Completo *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    TextField(
                      controller: _propietarioController,
                      decoration: InputDecoration(
                        hintText: 'Propietario *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    TextField(
                      controller: _telefonoController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Celular *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    TextField(
                      controller: _direccionController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Dirección *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    (selectedMunicipio == "")
                        ? Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text('Ciudad donde opera*',
                                  style: CustomStyles()
                                      .getStyleFontWithFontWeight(Colors.black,
                                          12.0, FontWeight.normal),
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
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList();
                        },
                        items: options
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value != '' ? value : ''),
                          );
                        }).toList(),
                      ),
                    ),
                    TextField(
                      controller: _nitController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'NIT *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    TextField(
                      controller: _serviciosController,
                      decoration: InputDecoration(
                        hintText: 'Servicios *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    TextField(
                      controller: _marcasController,
                      decoration: InputDecoration(
                        hintText: 'Marcas *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    TextField(
                      controller: _numeroCuentaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Numero de cuenta *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                    TextField(
                      controller: _bancoController,
                      decoration: InputDecoration(
                        hintText: 'Banco *',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                  ],
                )),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(children: [
                  Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SizedBox(width: 20.0),
                    ),
                    Expanded(
                      flex: 1,
                      child: ButtonTheme(
                        height: 40.0,
                        minWidth: 120.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Color(0xff1fc9d0))),
                          textColor: Colors.white,
                          color: Color(0xff1fc9d0),
                          child: Text(
                            'Guardar cambios',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 15.0)),
                          ),
                          onPressed: () async {
                            setState(() => loading = true);
                            await registrarTaller();
                            setState(() => loading = false);
                          },
                        ),
                      ),
                    ),
                  ]),
                ])),
          ),
          SizedBox(height: 20.0),
        ]),
      ),
    );
  }

  void loadInformation() {
    _nombreController.text = usuario.nombre;
    _propietarioController.text = usuario.propietario;
    _telefonoController.text = usuario.celular.toString();
    _direccionController.text = usuario.direccion;
    _nitController.text = usuario.nit;
    _serviciosController.text = usuario.servicios;
    _marcasController.text = usuario.marcas;
    _numeroCuentaController.text = usuario.cuentaBancaria;
    _bancoController.text = usuario.banco;
    if (selectedMunicipio == "") selectedMunicipio = usuario.ciudad;
    urlImage = usuario.urlImagen;
  }

  Future<void> registrarTaller() async {
    if (_nombreController.text.isEmpty ||
        _propietarioController.text.isEmpty ||
        _serviciosController.text.isEmpty ||
        _marcasController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _direccionController.text.isEmpty ||
        selectedMunicipio.isEmpty ||
        _nitController.text.isEmpty ||
        _numeroCuentaController.text.isEmpty ||
        _bancoController.text.isEmpty) {
      SistemaTools().mostrarAlert(
          context, '¡Lo sentimos!', 'Ningún campo puede estar vacío');
    } else {
      urlImage = '';
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
      UserTaller taller = UserTaller(
          uid: usuario.uid,
          email: usuario.email,
          password: usuario.password,
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
          cartera: usuario.cartera,
          urlImagen: urlImage ?? usuario.urlImagen);

      if (taller.direccion != usuario.direccion ||
          taller.ciudad != usuario.ciudad) {
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
      } else {
        taller.latitud = usuario.latitud;
        taller.longitud = usuario.longitud;
      }

      if (taller.latitud != null && taller.longitud != null) {
        try {
          await DatabaseService(uid: usuario.uid).updateTallerData(taller);
          SistemaTools().mostrarAlert(
              context, '¡Exito!', 'Información actualizada exitosamente.');
        } catch (Exception) {
          SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
              'No podemos hacer el registro, por favor vuelva a intentarlo');
        }
      }
    }
  }

  void _seleccionarFoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        urlImage = '';
        _file = null;
        _file = File(pickedFile.path);
      });
    } else {
      print('No hay imagen seleccionada');
    }
  }
}
