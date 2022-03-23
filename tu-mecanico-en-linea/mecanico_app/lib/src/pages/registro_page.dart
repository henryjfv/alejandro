import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/shared/loading.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';
import 'package:mecanico_app/src/providers/push_notifications_provider.dart';
import 'package:mecanico_app/src/utils/firebase_auth.dart';
import 'package:mecanico_app/src/utils/sistema.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  TextEditingController _nombreControler;
  TextEditingController _emailCotroller;
  TextEditingController _telefonoController;
  TextEditingController _passwordController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _nombreControler = TextEditingController(text: '');
    _emailCotroller = TextEditingController(text: '');
    _telefonoController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  //color: Color(0xff18203d),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/registro-fondo.png'),
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
                              'images/logo-blanco.png',
                              height: 150.0,
                            ),
                          ),
                          Text('¡Te damos la bienvenida!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 27.0))),
                          SizedBox(height: 20.0),
                          Text('Nos alegra que quieras ser parte del registro',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 15.0))),
                          SizedBox(height: 20.0),
                          TextField(
                            controller: _nombreControler,
                            decoration: InputDecoration(
                              hintText: 'Nombre *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _telefonoController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Teléfono *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          TextField(
                            controller: _emailCotroller,
                            keyboardType: TextInputType.emailAddress,
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
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Contraseña *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                          ),
                          const SizedBox(height: 20.0),
/*                           Row(
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
                              ]), */
                          /* const SizedBox(height: 30.0), */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                child: ButtonTheme(
                                  height: 40.0,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        side: BorderSide(
                                            color: Color(0xff0f6f94))),
                                    textColor: Colors.white,
                                    color: Color(0xff0f6f94),
                                    child: Text(
                                      'Ya tengo una cuenta',
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0)),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                child: ButtonTheme(
                                  height: 40.0,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        side: BorderSide(
                                            color: Color(0xff1fc9d0))),
                                    textColor: Colors.white,
                                    color: Color(0xff1fc9d0),
                                    child: Text(
                                      'Registrarme',
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0)),
                                    ),
                                    onPressed: () async {
                                      if (_nombreControler.text.isEmpty ||
                                          _emailCotroller.text.isEmpty ||
                                          _telefonoController.text.isEmpty ||
                                          _passwordController.text.isEmpty) {
                                        SistemaTools().mostrarAlert(
                                            context,
                                            '¡Lo sentimos!',
                                            'Ningún campo puede estar vacío');
                                      } else {
                                        setState(() => loading = true);
                                        UserApp res = await AuthProvider()
                                            .registerWithEmailAndPassword(
                                                _nombreControler.text.trim(),
                                                _emailCotroller.text.trim(),
                                                _telefonoController.text.trim(),
                                                _passwordController.text
                                                    .trim());
                                        if (res != null) {
                                          var notificador =
                                              Singleton().notificador;
                                          if (notificador == null) {
                                            notificador =
                                                new PushNotificationProvider();
                                            Singleton().notificador =
                                                notificador;
                                          }
                                          notificador.initNotifications();

                                          Navigator.pop(context);
                                          /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                    );
                                    */
                                        } else {
                                          SistemaTools().mostrarAlert(
                                              context,
                                              '¡Lo sentimos!',
                                              'No podemos hacer el registro, por favor vuelva a intentarlo');
                                          print(res);
                                        }
                                        setState(() => loading = false);
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          ButtonTheme(
                            height: 40.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: BorderSide(color: Color(0xff0f6f94))),
                              textColor: Colors.white,
                              color: Color(0xff0f6f94),
                              child: Text(
                                'Registarme con una cuenta google',
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 12.0)),
                              ),
                              onPressed: () async {
                                await obtenerDatosGoogle();
                              },
                            ),
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

  Future<void> obtenerDatosGoogle() async {
    await AuthProvider().getGoogleInformation().then((value) => setState(() {
          _nombreControler.text = value.nombre;
          _emailCotroller.text = value.email;
        }));
  }
}
