import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/utils/Colors.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/Decorations.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'ServicioNoCompletado.dart';
import 'ServiciosTomadosPage.dart';

class DomicilioPage extends StatefulWidget {
  DomicilioPage({Key key}) : super(key: key);

  @override
  _DomicilioPageState createState() => _DomicilioPageState();
}

class _DomicilioPageState extends State<DomicilioPage> {
  Domicilio domicilio;
  int _counter = 120;
  Timer _timer;
  bool empezarTimer = false;
  bool mostrarBotones = false;
  bool isLoading = true;
  String valorPago = "50.000";

  void _startTimer() {
    _counter = 120;
/*     if (_timer != null) {
      _timer.cancel();
    } */
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      try {
        if (this.mounted) {
          setState(() {
            if (_counter > 0) {
              _counter--;
            } else {
              _timer.cancel();
              mostrarBotones = true;
            }
          });
        } else {
          _timer.cancel();
        }
      } catch (ex) {
        print(ex);
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService().configuracion.then((config) {
      if (config.valorDomicilioMecanicos != null &&
          config.valorDomicilioMecanicos != "") {
        double valor = double.tryParse(config.valorDomicilioMecanicos);
        this.setState(() {
          valorPago = expresionRegular(valor);
        });
      }
    });

    domicilio = Provider.of<Domicilio>(context) ??
        Domicilio(
            estado: EstadoDomicilio.Creado, nombreMecanico: "Nombre mecanico");
/*     if (domicilio.estado == EstadoDomicilio.Creado) {
      _startTimer();
    } */
    return pantallaDomiclio();
  }

  Widget pantallaDomiclio() {
    Widget contenido;
    /* print(domicilio.estado); */
    if (domicilio.estado == EstadoDomicilio.Creado) {
      contenido = _vistaCargandoBuscandoMecanico();
    } else {
      contenido = _formularioMecanicoEnCamino();
    }
    contenido = _fondo(context, contenido);
    return contenido;
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
                  decoration: decoracionCardCurvo,
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
                                          height: 40.0,
                                          minWidth: 200.0,
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
                                          domicilio.estado ==
                                                      EstadoDomicilio.Tomado &&
                                                  !domicilio.domicilioPagado
                                              ? 'Pagar'
                                              : 'Siguiente',
                                          style: CustomStyles()
                                              .getStyleFontWithFontWeight(
                                                  Colors.black,
                                                  12.0,
                                                  FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        onPressed: () {
                                          if (domicilio.estado ==
                                                  EstadoDomicilio.Tomado &&
                                              !domicilio.domicilioPagado) {
                                            showPaymethod(context);
                                          } else {
                                            DatabaseService()
                                                .updateEstadoDomicilio(
                                                    domicilio)
                                                .then((value) {
                                              Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ServiciosTomados(),
                                                ),
                                              );
                                            });
                                          }
                                        },
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

  Widget _vistaCargandoBuscandoMecanico() {
    if (!empezarTimer) {
      empezarTimer = true;
      _startTimer();
    }
    return Column(
      children: [
        Text(
          'Estamos buscando a tu mecánico',
          style: CustomStyles()
              .getStyleFontWithFontWeight(Colors.white, 12.0, FontWeight.bold),
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
                  'Mecánico',
                  style: CustomStyles().getStyleFont(Colors.grey, 10.0),
                  textAlign: TextAlign.left,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Buscando mecánico ...',
                  style: CustomStyles().getStyleFontWithFontWeight(
                      colorTitleText, 15.0, FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        (DateFormat('mm:ss').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    _counter * 1000)))
                            .toString(),
                        style: CustomStyles().getStyleFont(Colors.grey, 18.0),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SpinKitFadingCircle(
                        color: Colors.blue,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 1,
                            width: double.infinity,
                            child: Container(
                              color: colorGrey,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Espera un momento mientras encontramos a tu mecánico más cercano.',
                            textAlign: TextAlign.center,
                            style: CustomStyles().getStyleFontWithFontWeight(
                                Colors.black, 12.0, FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (mostrarBotones)
                  ? ButtonTheme(
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
                        child: Text('Intentar nuevamente'),
                        onPressed: () {
                          setState(() {
                            mostrarBotones = false;
                          });
                          _startTimer();
                        },
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              (mostrarBotones)
                  ? ButtonTheme(
                      height: 50.0,
                      minWidth: 250.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: colorOrange,
                          ),
                        ),
                        textColor: Colors.white,
                        color: colorOrange,
                        child: Text(
                          'Cancelar servicio',
                          style:
                              CustomStyles().getStyleFont(Colors.white, 12.0),
                        ),
                        onPressed: () {
                          mostrarAlerta(context);
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fondo(BuildContext context, Widget contenido) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          height: size.height * .6,
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
              bottomRight: Radius.circular(70),
            ),
          ),
          //layoutCodigo()
        ),
        contenido
      ],
    );
  }

  void showPaymethod(BuildContext context) {
    setState(() => isLoading = true);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              isLoading ? Center(child: CircularProgressIndicator()) : null,
              WebView(
                onPageFinished: (finish) {
                  setState(() => isLoading = false);
                },
                initialUrl: '',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) async {
                  String referencia = '';
                  if (domicilio.referenciaPago > 0) {
                    referencia = domicilio.referenciaPago.toString();
                  } else {
                    referencia = await _generarReferencia();
                    domicilio.referenciaPago = int.parse(referencia);
                    DatabaseService db = DatabaseService();
                    await db.updateReferenciaDomicilio(domicilio);
                  }
                  Configuracion config = await DatabaseService().configuracion;
                  final String contentBase64 =
                      base64Encode(const Utf8Encoder().convert('''<script>
                                              window.onload = function() {
                                                document.getElementById("btnPagar").click();
                                              };
                                              </script>
                                              <form action="https://checkout.wompi.co/p/" method="GET">
                                              <!-- OBLIGATORIOS -->
                                              <input type="hidden" name="public-key" value="''' +
                          config.llavePubWompi +
                          '''" />
                                              <input type="hidden" name="currency" value="COP" />
                                              <input type="hidden" name="amount-in-cents" value="''' +
                          config.valorDomicilioMecanicos +
                          '''00" />
                                              <input type="hidden" name="reference" value="$referencia" />
                                              <!-- OPCIONALES -->
                                              <button style="display:none;" id="btnPagar" type="submit">Pagar con Wompi</button> 
                                              </form>'''));
                  await webViewController
                      .loadUrl('data:text/html;base64,$contentBase64');
                },
              ),
            ],
          ),
        );
      },
    ).then((value) async {
      Configuracion config = await DatabaseService().configuracion;
      var url = config.urlPagos +
          "/transactions?reference=" +
          domicilio.referenciaPago.toString();
      try {
        var res = await http.get(url, headers: {
          HttpHeaders.authorizationHeader: "Bearer " + config.llavePrvWompi
        });
        if (res.statusCode == 200) {
          var jsonResponse = jsonDecode(res.body);
          var dataTransaction = jsonResponse['data'];
          if (dataTransaction.length > 0) {
            for (var item in dataTransaction) {
              var status = item['status'];
              print('$status.');
              print('$dataTransaction.');

              if (status == 'APPROVED') {
                await finalizaDomicilio(domicilio);
              }
            }
          }
        } else {
          print('Request failed with status: ${res.statusCode}.');
        }
      } catch (e) {
        print('EXCEPCION ERROR PETICION');
        print(e);
      }
    });
    //Modificar el pago y las referencias para traerlas por bd y cambiar los valores en wompi
  }

  Future<String> _generarReferencia() async {
    Configuracion config = await DatabaseService().configuracion;
    config.consecutivoPagos = config.consecutivoPagos + 1;
    DatabaseService().updateConsecutivoPagoConfig(config);
    return config.consecutivoPagos.toString();
  }

  Future<void> finalizaDomicilio(Domicilio domicilio) async {
    domicilio.estado = EstadoDomicilio.Pagado;
    try {
      DatabaseService db = DatabaseService();
      domicilio.domicilioPagado = true;
      await db.updateEstadoPagoDomicilio(domicilio);
      await db.updateEstadoDomicilio(domicilio);
      await db.notificarMecanico(
          domicilio.idMecanico,
          'Servicio pagado',
          'El cliente ' +
              domicilio.nombreUsuario +
              " está esperando el servicio");
      SistemaTools()
          .mostrarAlert(context, '¡Exito!', 'Domicilio pagado exitosamente.');
    } catch (Exception) {
      SistemaTools().mostrarAlert(context, '¡Lo sentimos!',
          'No podemos procesar el pago del domicilio, por favor vuelva a intentarlo');
    }
  }

  void mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "¿Estás seguro que deseas cancelar el servicio?",
              style: CustomStyles().getStyleFontWithFontWeight(
                  Colors.black, 18.0, FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    'SI CANCELAR',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    domicilio.estado = EstadoDomicilio.Cancelado;
                    DatabaseService()
                        .updateEstadoDomicilio(domicilio)
                        .then((value) {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              ServicioNoCompletado(domicilio, null),
                        ),
                      );
                    });
                  }),
              FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
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
