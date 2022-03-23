import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mecanico_app/src/models/Cartera.dart';
import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:mecanico_app/src/models/servicio.dart';
import 'package:mecanico_app/src/pages/ServicioNoCompletado.dart';
import 'package:mecanico_app/src/pages/ServicioTerminado.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/utils/AppBarConfig.dart';
import 'package:mecanico_app/src/utils/Colors.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/Decorations.dart';
import 'package:mecanico_app/src/utils/sistema.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleServicio extends StatelessWidget {
  final Domicilio dom;
  final Servicio servicio;
  final bool tipo;
  const DetalleServicio({Key key, this.dom, this.servicio, @required this.tipo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .6,
            width: double.infinity,
            decoration: fondoCurvoGradient,
          ),
          SingleChildScrollView(
            child:
                tipo ? _detalleDomicilio(context) : _detalleServicio(context),
          ),
        ],
      ),
    );
  }

  Widget _detalleDomicilio(BuildContext context) {
    bool mostrarBotonesDomicilio = (dom.estado != EstadoDomicilio.Cancelado &&
        dom.estado != EstadoDomicilio.Terminado);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          decoration: decoracionCardCurvo,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 8.0, 8.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mecánico',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      dom.nombreMecanico,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Servicio tomado',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      DateFormat.yMMMMd(
                        Localizations.localeOf(context).toString(),
                      ).format(
                        DateTime.parse(dom.fecha),
                      ),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Proceso',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Un mecánico irá a tu ubicacíon',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Ciudad / Municipio',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      dom.ciudadMunicipio,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Barrio',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      dom.barrio,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Estado del servicio',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      EnumToString.convertToString(dom.estado),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Marca del vehículo',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      dom.marcaCarro,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Modelo',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      dom.modelo,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Kilometraje',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      dom.kilometraje,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Ubicación',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      dom.ubicacionActual,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Tipo de falla',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'El carro no arranca',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.assetNetwork(
                      image: dom.urlImagenMecanico,
                      placeholder: 'images/placeholder_avatar.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        (mostrarBotonesDomicilio)
            ? ButtonTheme(
                height: 50.0,
                minWidth: 250.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
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
                        style: CustomStyles().getStyleFont(Colors.white, 12.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: FaIcon(FontAwesomeIcons.whatsapp),
                      )
                    ],
                  ),
                  onPressed: () => _openWhatsApp(context),
                ),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        (mostrarBotonesDomicilio)
            ? ButtonTheme(
                height: 50.0,
                minWidth: 250.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.green),
                  ),
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text(
                    'Finalizar servicio',
                    style: CustomStyles().getStyleFont(Colors.white, 12.0),
                  ),
                  onPressed: () {
                    DatabaseService().configuracion.then((config) {
                      double valor = 50000;
                      if (config.valorDomicilioMecanicos != null &&
                          config.valorDomicilioMecanicos != "") {
                        valor = double.tryParse(config.valorDomicilioMecanicos);
                      }
                      DatabaseService db = DatabaseService(uid: dom.idUsuario);
                      //
                      Cartera cartera = new Cartera(
                          cuenta: TipoCuenta.Domicilio,
                          estado: EstadoCartera.Pendiente,
                          idServicioPrestado: dom.referenciaPago.toString(),
                          valor: valor);

                      db.addCartera(cartera, dom.idMecanico);
                      db.updateCarteraMecanico(dom.idMecanico, valor);
                      dom.estado = EstadoDomicilio.Terminado;
                      db.updateEstadoDomicilio(dom).then((value) {
                        db.notificarMecanico(
                            dom.idMecanico,
                            'Servicio Finalizado',
                            'El cliente ' +
                                dom.nombreUsuario +
                                " ha finalizado el servicio");

                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ServicioTerminado(),
                          ),
                        );
                      });
                    });
                  },
                ),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        (mostrarBotonesDomicilio)
            ? ButtonTheme(
                height: 50.0,
                minWidth: 250.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: colorOrange),
                  ),
                  textColor: Colors.white,
                  color: colorOrange,
                  child: Text(
                    'Cancelar servicio',
                    style: CustomStyles().getStyleFont(Colors.white, 12.0),
                  ),
                  onPressed: () {
                    mostrarAlerta(context, true);
                  },
                ),
              )
            : Container(),
        SizedBox(
          height: 80.0,
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
    );
  }

  Widget _detalleServicio(BuildContext context) {
    bool mostrarBotonesServicio =
        (servicio.estado != EstadoServicio.Cancelado &&
            servicio.estado != EstadoServicio.Terminado);

    bool mostrarBotonConfirmado =
        (servicio.estado == EstadoServicio.Terminado && !servicio.confirmado);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          decoration: decoracionCardCurvo,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 8.0, 8.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Taller',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      servicio.nombreTaller != null
                          ? servicio.nombreTaller
                          : '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Servicio tomado',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      DateFormat.yMMMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(
                            DateTime.parse(servicio.fecha),
                          ) +
                          " " +
                          servicio.hora,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Proceso',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      servicio.tipoDeServicio,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Ciudad / Municipio',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      servicio.ciudad,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Código',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      servicio.codigo,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Estado del servicio',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      EnumToString.convertToString(servicio.estado) +
                          ((servicio.confirmado)
                              ? " - Confirmado"
                              : (servicio.estado == EstadoServicio.Terminado)
                                  ? " - Sin confirmar"
                                  : ""),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Valor del servicio',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "\$" + expresionRegular(servicio.valorServicio),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Dirección del taller',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      servicio.direccion,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0XFF329D9C),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.assetNetwork(
                      image: servicio.urlImagenTaller,
                      placeholder: 'images/placeholder_avatar.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        (mostrarBotonesServicio)
            ? ButtonTheme(
                height: 50.0,
                minWidth: 250.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
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
                        style: CustomStyles().getStyleFont(Colors.white, 12.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: FaIcon(FontAwesomeIcons.whatsapp),
                      )
                    ],
                  ),
                  onPressed: () => _openWhatsApp(context),
                ),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        (mostrarBotonConfirmado)
            ? ButtonTheme(
                height: 50.0,
                minWidth: 250.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.green),
                  ),
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text(
                    'Confirmar servicio',
                    style: CustomStyles().getStyleFont(Colors.white, 12.0),
                  ),
                  onPressed: () {
                    _confirmarServicio(context);
                  },
                ),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        (mostrarBotonesServicio)
            ? ButtonTheme(
                height: 50.0,
                minWidth: 250.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: colorOrange),
                  ),
                  textColor: Colors.white,
                  color: colorOrange,
                  child: Text(
                    'Cancelar servicio',
                    style: CustomStyles().getStyleFont(Colors.white, 12.0),
                  ),
                  onPressed: () {
                    mostrarAlerta(context, false);
                  },
                ),
              )
            : Container(),
        SizedBox(
          height: 90.0,
        ),
        Text(
          'Recuerda que cualquier duda puedes escribirnos a tumecanicoenlinea2020@gmail.com',
          style: CustomStyles().getStyleFont(Colors.teal, 12.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _appbar(context) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorBackground,
      actions: AccionesToolbar(context: context).getAcciones(),
    );
  }

  void mostrarAlerta(BuildContext context, bool esDomicilio) {
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
                    _cancelarServicio(context, esDomicilio);
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

  void _cancelarServicio(BuildContext context, bool esDomicilio) {
    if (esDomicilio) {
      dom.estado = EstadoDomicilio.Cancelado;
      var db = DatabaseService(uid: dom.idUsuario);
      db.updateEstadoDomicilio(dom).then((value) {
        db.notificarMecanico(dom.idMecanico, 'Servicio Cancelado',
            'El cliente ' + dom.nombreUsuario + " ha cancelado el servicio");
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => ServicioNoCompletado(dom, null),
          ),
        );
      });
    } else {
      servicio.estado = EstadoServicio.Cancelado;
      var db = DatabaseService(uid: servicio.idUsuario);
      db.updateEstadoServicioData(servicio).then((value) {
        db.notificarTaller(
            servicio.idTaller,
            'Servicio Cancelado',
            'El cliente ' +
                servicio.nombreUsuario +
                " ha cancelado el servicio");
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => ServicioNoCompletado(null, servicio),
          ),
        );
      });
    }
  }

  void _openWhatsApp(BuildContext context) async {
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

  void _finalizarServicio(BuildContext context) {
    servicio.estado = EstadoServicio.Terminado;
    var db = DatabaseService(uid: servicio.idUsuario);
    db.updateEstadoServicioData(servicio).then((value) {
      db.notificarTaller(
          servicio.idTaller,
          'Servicio Finalizado',
          'El cliente ' +
              servicio.nombreUsuario +
              " ha finalizado el servicio");

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ServicioTerminado(),
        ),
      );
    });
  }

  void _confirmarServicio(BuildContext context) {
    var db = DatabaseService(uid: servicio.idUsuario);
    servicio.confirmado = true;
    db.updateEstadoServicioData(servicio).then((value) {
      db.notificarTaller(
          servicio.idTaller,
          'Servicio confirmado',
          'El cliente ' +
              servicio.nombreUsuario +
              " ha confirmado el servicio");
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ServicioTerminado(),
        ),
      );
    });
  }

  String expresionRegular(double numero) {
    NumberFormat f = new NumberFormat("#,###.0#", "es_US");
    String result = f.format(numero);
    return result;
  }
}
