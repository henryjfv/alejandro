import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mecanico_app/src/pages/registro_page.dart';
import 'package:mecanico_app/src/pages/shared/loading.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';
import 'package:mecanico_app/src/providers/push_notifications_provider.dart';
import 'package:mecanico_app/src/utils/Colors.dart';
import 'package:mecanico_app/src/utils/firebase_auth.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:mecanico_app/src/utils/styles.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailCotroller;
  TextEditingController _passwordController;
  TextEditingController _recuperarContrller;
  bool loading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailCotroller = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _recuperarContrller = TextEditingController(text: '');
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
                      image: AssetImage('images/login-fondo.png'),
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
                            // color: Colors.yellow,
                            child: Image.asset(
                              'images/logo-blanco.png',
                              height: 150.0,
                            ),
                          ),
                          Text('¡Te damos la bienvenida!',
                              textAlign: TextAlign.center,
                              style: CustomStyles()
                                  .getStyleFont(Colors.white, 25.0)),
                          SizedBox(height: 20.0),
                          Text('Ingresa',
                              textAlign: TextAlign.center,
                              style: CustomStyles()
                                  .getStyleFont(Colors.white, 18.0)),
                          SizedBox(height: 20.0),
                          TextField(
                            controller: _emailCotroller,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Correo electrónico *',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style:
                                CustomStyles().getStyleFont(Colors.white, 15.0),
                          ),
                          SizedBox(height: 30.0),
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
                            style:
                                CustomStyles().getStyleFont(Colors.white, 15.0),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                                child: Text('Olvide la contraseña',
                                    style: CustomStyles()
                                        .getStyleFont(Colors.white, 18.0)),
                                onPressed: () {
                                  mostrarResetearPass(context);
                                }),
                          ),
                          //const SizedBox(height: 20.0),
/*                 Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('Olvide la contraseña',
                          textAlign: TextAlign.right,
                          style:
                              CustomStyles().getStyleFont(Colors.white, 18.0)),
                    ]), */

                          const SizedBox(height: 30.0),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 250.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              textColor: Colors.white,
                              color: colorBackground,
                              child: Text(
                                'Ingresar',
                                style: CustomStyles()
                                    .getStyleFont(Colors.white, 15.0),
                              ),
                              onPressed: () async {
                                if (_emailCotroller.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  SistemaTools().mostrarAlert(
                                      context,
                                      '¡Lo sentimos!',
                                      'El correo y la contraseña no deben estar vacíos');
                                  return;
                                } else {
                                  setState(() => loading = true);
                                  bool res = await AuthProvider()
                                      .signInWithEmailAndPassword(
                                          _emailCotroller.text.trim(),
                                          _passwordController.text.trim());
                                  if (!res) {
                                    SistemaTools().mostrarAlert(
                                        context,
                                        '¡Lo sentimos!',
                                        'No podemos iniciar sesión, por favor revisa el correo y la contraseña e intenta de nuevo');
                                  } else {
                                    var notificador = Singleton().notificador;
                                    if (notificador == null) {
                                      notificador =
                                          new PushNotificationProvider();
                                      Singleton().notificador = notificador;
                                    }
                                    notificador.initNotifications();
                                  }
                                  setState(() => loading = false);
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 250.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              textColor: Colors.white,
                              color: colorAccent,
                              child: Text(
                                'Registrate',
                                style: CustomStyles()
                                    .getStyleFont(Colors.white, 15.0),
                              ),
                              onPressed: () async {
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => RegistroPage()),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 250.0,
                            child: RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.white,
                              color: Colors.blue,
                              label: Text(
                                "Inicia con Google",
                                style: CustomStyles()
                                    .getStyleFont(Colors.white, 15.0),
                              ),
                              icon: Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                setState(() => loading = true);
                                bool res =
                                    await AuthProvider().loginWithGoogle();
                                if (!res) {
                                  SistemaTools().mostrarAlert(
                                      context,
                                      '¡Lo sentimos!',
                                      'No podemos iniciar sesión con google');
                                }
                                setState(() => loading = false);
                              },
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          );
  }

  void mostrarResetearPass(BuildContext context) {
    _recuperarContrller.clear();
    bool envio = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Recuperar Contraseña",
              style: CustomStyles().getStyleFontWithFontWeight(
                  Colors.black, 18.0, FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Ingresa tu correo electrónico abajo y se te enviará la información necesaria para recuperar tu contraseña.",
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
}
