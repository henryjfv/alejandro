import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/servicio.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';
import 'package:tutaller_app/src/pages/talleres/servicio-item.dart';

typedef callBackPrincipal = void Function(void Function());

class ServicioListItem extends StatefulWidget {
  ServicioListItem(this.funcion);
  callBackPrincipal funcion;
  @override
  _ServicioListItemState createState() => _ServicioListItemState();
}

class _ServicioListItemState extends State<ServicioListItem> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    final servicios = Provider.of<List<Servicio>>(context) ?? [];
    final serviciosActivos =
        servicios.where((e) => e.estado == EstadoServicio.Creado).toList();
    return Container(
      child: SizedBox(
        height: 200.0,
        child: new ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          addAutomaticKeepAlives: true,
          key: UniqueKey(),
          itemCount: serviciosActivos.length,
          itemBuilder: (context, index) {
            return ServicioItem(
                servicio: serviciosActivos[index], funcion: widget.funcion);
          },
        ),
      ),
    );
  }
}
