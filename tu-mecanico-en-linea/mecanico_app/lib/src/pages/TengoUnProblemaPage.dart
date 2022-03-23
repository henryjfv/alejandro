import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:mecanico_app/src/utils/notificadorEmail.dart';
import 'package:mecanico_app/src/utils/utils.dart';

class TengoUnProblema extends StatefulWidget {
  const TengoUnProblema({Key key}) : super(key: key);

  @override
  _TengoUnProblemaState createState() => _TengoUnProblemaState();
}

class _TengoUnProblemaState extends State<TengoUnProblema> {
  TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _menuToolbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'images/logo_oscuro.png',
              width: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              child: Text(
                'Recuerda que cualquier duda puedes escribirnos a tumecanicoenlinea@gmail.com o marcanos a +57 321 388 6755',
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'Tengo un problema',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Escribenos',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70),
              ),
            ),
            InkWell(
              onTap: () async {
                Configuracion config = await DatabaseService().configuracion;
                NotificadorEmail notificador = NotificadorEmail(
                    asunto: "Tengo un problema!!",
                    destinatario: config.emailContacto,
                    cuerpo: "Mensaje: " + "<br/>" + _descripcionController.text,
                    isHTML: true);

                await notificador.send();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                        color: Color(0XFF0f6f94),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
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
          ],
        ),
      ),
    );
  }

  Widget _menuToolbar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff001558), Color(0xff0F6F94)],
            stops: [0.5, 1.5],
          ),
        ),
      ),
      title: Text(
        '¿Tienes algún problema?',
        style: TextStyle(fontSize: 17.0),
      ),
      actions: AccionesToolbar(context: context).getAcciones(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(50),
        ),
      ),
    );
  }

  _seleccionMenu(int value) {}
}
