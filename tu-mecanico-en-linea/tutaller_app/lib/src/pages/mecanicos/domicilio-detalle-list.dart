import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'domicilio-detalle-item.dart';

/* class DomicilioDetalleList extends StatefulWidget {
  @override
  _DomicilioDetalleListState createState() => _DomicilioDetalleListState();
} */

class DomicilioDetalleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final domicilios = Provider.of<List<Domicilio>>(context) ?? [];
    final double height = MediaQuery.of(context).size.height;

    return (domicilios.length > 0)
        ? Container(
            child: SizedBox(
              height: height - 228.0,
              child: new ListView.builder(
                key: UniqueKey(),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: domicilios.length,
                itemBuilder: (context, index) {
                  final dom = domicilios[index];
                  return new DomicilioDetalleItem(domicilio: dom);
                },
              ),
            ),
          )
        : buildMensajeVacio();
  }

  Widget buildMensajeVacio() {
    return Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Center(
                    child: Text("No se encontraron domicilios.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Color(0xff1fc9d0),
                                fontSize: 22.0,
                                fontWeight: FontWeight.normal)))),
              ),
              Row(children: <Widget>[
                SizedBox(width: 20.0),
                Expanded(
                    child: Divider(
                  color: Colors.black,
                )),
                Expanded(
                    child: Divider(
                  color: Colors.black,
                )),
                SizedBox(width: 20.0),
              ]),
            ],
          ),
        ));
  }
}
