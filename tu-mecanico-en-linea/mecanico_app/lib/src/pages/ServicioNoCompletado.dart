import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:mecanico_app/src/models/servicio.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/notificadorEmail.dart';
import 'package:mecanico_app/src/utils/utils.dart';

class ServicioNoCompletado extends StatefulWidget {
  Domicilio domicilio;
  Servicio servicio;
  ServicioNoCompletado(this.domicilio, this.servicio);
  @override
  _ServicioNoCompletado createState() => _ServicioNoCompletado();
}

class _ServicioNoCompletado extends State<ServicioNoCompletado> {
  TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    Domicilio domicilio = widget.domicilio;
    Servicio servicio = widget.servicio;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,

        elevation: 0,
        backgroundColor: colorBackground,
        // actions: AccionesToolbar(context: context).getAcciones(),
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
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('images/Error.png'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8.0, 20, 8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '¿Cuétanos que sucedió?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _descripcionController,
                                maxLines: 8,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String nombreCliente = (domicilio != null)
                                    ? domicilio.nombreUsuario
                                    : servicio.nombreUsuario;
                                Configuracion config =
                                    await DatabaseService().configuracion;
                                NotificadorEmail notificador = NotificadorEmail(
                                    asunto: "Servicio cancelado",
                                    destinatario: config.emailContacto,
                                    cuerpo: "Cliente: " +
                                        nombreCliente.toUpperCase() +
                                        "<br/>" +
                                        _descripcionController.text,
                                    isHTML: true);

                                await notificador.send();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                        color: Color(0XFF0f6f94),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Text(
                                      'Enviar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Icon(
                                    Icons.send,
                                    color: Color(0XFF0f6f94),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              child: Text(
                                'Revisaremos tu caso y en cuyo caso te devolveremos tu dinero',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
