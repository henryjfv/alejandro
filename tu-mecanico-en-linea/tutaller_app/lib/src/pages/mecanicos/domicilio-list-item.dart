import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'package:tutaller_app/src/pages/shared/singleTone.dart';
import 'package:tutaller_app/src/utils/sistema.dart';

import 'domicilio-item.dart';

typedef callBackPrincipal = void Function(void Function());

class DomicilioListItem extends StatefulWidget {
  DomicilioListItem(this.funcion);
  callBackPrincipal funcion;
  @override
  _DomicilioListItemState createState() => _DomicilioListItemState();
}

class _DomicilioListItemState extends State<DomicilioListItem> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    final domicilios = Provider.of<List<Domicilio>>(context) ?? [];
    final domiciliosCercanos = getDomicilioCercanos(domicilios);

    return Container(
      child: new ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        key: UniqueKey(),
        itemCount: domiciliosCercanos.length,
        itemBuilder: (context, index) {
          return DomicilioItem(
              domicilio: domiciliosCercanos[index], funcion: widget.funcion);
        },
      ),
    );
  }

  List<Domicilio> getDomicilioCercanos(List<Domicilio> domicilios) {
    var currentLocation = Singleton().currentLocation;
    double distancia = Singleton().distanciaBusqueda;
    List<Domicilio> filtro = <Domicilio>[];
    if (currentLocation != null) {
      for (int i = 0; i < domicilios.length; i++) {
        var dom = domicilios[i];
        if (dom.latitud != null &&
            dom.longitud != null &&
            dom.latitud != 0 &&
            dom.longitud != 0) {
          double lejania = SistemaTools().calculateKilometrageDistance(
              currentLocation.latitude,
              currentLocation.longitude,
              dom.latitud,
              dom.longitud);
          if (lejania <= distancia) {
            filtro.add(dom);
          }
        }
      }
    }
    return filtro;
  }
}
