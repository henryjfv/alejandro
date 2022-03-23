import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/configuracion.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/menuToolbar.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';
import 'package:tutaller_app/src/utils/notificadorEmail.dart';
import 'package:tutaller_app/src/utils/styles.dart';

class AyudaMecanico extends StatefulWidget {
  @override
  _AyudaMecanicoItemState createState() => _AyudaMecanicoItemState();
}

class _AyudaMecanicoItemState extends State<AyudaMecanico> {
  UserMecanico usuario;
  double width = 0;
  TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    usuario = Provider.of<UserMecanico>(context) ??
        UserMecanico(nombre: 'Nombre de mecanico', email: "email@email.com");
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        buildFormulario(),
        Container(
          color: Colors.grey[50],
          height: 160.0,
          child: Row(
            children: [
              SizedBox(width: 140.0),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 80.0),
                    Center(
                        child: Text(usuario.nombre,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black, fontSize: 16.0)))),
                    Expanded(
                      child: Text(usuario.email,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.black38, fontSize: 14.0))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: FractionalOffset.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: usuario.urlImagen.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      image: usuario.urlImagen,
                      placeholder: 'assets/img/placeholder_avatar.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/img/placeholder_avatar.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        MenuToolbar().menuToolbarLight(),
      ],
    );
  }

  Widget buildFormulario() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 160.0),
        child: Column(children: [
          Container(
            width: 150.0,
            height: 90.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new AssetImage('assets/img/logo_splash3.png'))),
          ),
          Row(children: <Widget>[
            SizedBox(width: 20.0),
            Expanded(child: Divider()),
            Expanded(child: Divider()),
            SizedBox(width: 20.0),
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Recuerda que cualquier duda puedes escribirnos \na tumecanicoenlinea@gmail.com',
                textAlign: TextAlign.center,
                style: CustomStyles().getStyleFont(Colors.black, 15.0),
              ),
              SizedBox(height: 26.0),
              Text(
                'Tengo un problema',
                textAlign: TextAlign.center,
                style: CustomStyles().getStyleFont(Colors.black, 26.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'Escribenos',
                textAlign: TextAlign.center,
                style: CustomStyles().getStyleFont(Colors.black, 15.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextField(
                      controller: _descripcionController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                        fillColor: Colors.white,
                      )),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ButtonTheme(
                height: 40.0,
                minWidth: 120.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: Color(0xff1fc9d0))),
                  textColor: Colors.white,
                  color: Color(0xff1fc9d0),
                  child: Text(
                    'Enviar',
                    style: GoogleFonts.openSans(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                  ),
                  onPressed: () async {
                    Configuracion config =
                        await DatabaseService().configuracion;
                    NotificadorEmail notificador = NotificadorEmail(
                        asunto: "Mecanico - Tengo un problema",
                        destinatario: config.emailContacto,
                        cuerpo: "Mecanico: " +
                            usuario.nombre.toUpperCase() +
                            "<br/>" +
                            _descripcionController.text,
                        isHTML: true);

                    await notificador.send();
                  },
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
