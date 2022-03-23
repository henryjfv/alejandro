import 'package:flutter/material.dart';
import 'package:mecanico_app/src/utils/utils.dart';

class ServicioTerminado extends StatelessWidget {
  const ServicioTerminado({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        actions: AccionesToolbar(context: context).getAcciones(),
      ),
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
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/Correcto.png'),
                SizedBox(height: 20),
                Text(
                  '¡Servicio completado con éxtio!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
