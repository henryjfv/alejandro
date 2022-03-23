import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mecanico_app/src/models/HistorialModel/Historial.dart';
import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/servicio.dart';
import 'package:mecanico_app/src/pages/DetalleServicio.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/pages/shared/loading.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:intl/intl.dart';

class HistorialServicio implements ListHistorial {
  Servicio servicio;
  Key key;
  HistorialServicio({this.key, this.servicio});

  @override
  Widget buildServicio(BuildContext context) {
    String image = '';

    return Container(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Container(
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
                        'Estado',
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
                        'Servicio tomado',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        DateFormat.yMMMMd(
                          Localizations.localeOf(context).toString(),
                        ).format(
                          DateTime.parse(servicio.fecha),
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
                        'Tipo de falla',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        servicio.descripcion,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0XFF329D9C),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => DetalleServicio(
                                  dom: new Domicilio(),
                                  servicio: servicio,
                                  tipo: false,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Ver servicio',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF329D9C),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: (servicio.urlImagenTaller != null &&
                              servicio.urlImagenTaller != "")
                          ? FadeInImage.assetNetwork(
                              image: servicio.urlImagenTaller,
                              placeholder: 'images/placeholder_avatar.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'images/placeholder_avatar.png',
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
        ),
      ),
    );
  }

  @override
  Widget buildDomicilio(BuildContext context) {
    return Container();
  }
}
