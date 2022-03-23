import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/configuracion.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/colors.dart';
import 'package:tutaller_app/src/pages/shared/decoration.dart';
import 'package:tutaller_app/src/pages/shared/menuToolbar.dart';
import 'package:tutaller_app/src/utils/notificadorEmail.dart';
import 'package:tutaller_app/src/utils/styles.dart';
import 'package:tutaller_app/src/utils/DatabaseService.dart';

class RetiroMecanico extends StatefulWidget {
  @override
  _RetiroMecanicoItemState createState() => _RetiroMecanicoItemState();
}

class _RetiroMecanicoItemState extends State<RetiroMecanico> {
  UserMecanico usuario;
  double width = 0;
  TextEditingController _descripcionController;
  String cantidadRealizada = "";

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
    DatabaseService().getDomiciliosRealizados(usuario.uid).forEach((element) {
      if (cantidadRealizada == "") {
        setState(() {
          cantidadRealizada = element.length.toString();
        });
      }
    });

    return Stack(
      children: <Widget>[
        Align(
          alignment: FractionalOffset.topCenter,
          child: Container(
              margin: const EdgeInsets.only(top: 160.0),
              width: 200.0,
              height: 370.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/img/telefono.png')))),
        ),
        Center(child: buildFormulario()),
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
    String valor = expresionRegular(usuario.cartera);
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 230.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(25, 0, 20, 20),
                padding: EdgeInsets.fromLTRB(90, 20, 20, 20),
                decoration: decoracionTitulos,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '\$$valor cop',
                        style: CustomStyles().getStyleFontWithFontWeight(
                            colorTitleText, 15.0, FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Tu saldo actual',
                        style: CustomStyles().getStyleFont(Colors.grey, 10.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.check_circle,
                                  //darken the icon if it is selected or else give it a different color
                                  color: Colors.greenAccent.shade700),
                              SizedBox(width: 10.0),
                              Text(
                                '$cantidadRealizada servicios realizados',
                                textAlign: TextAlign.center,
                                style: CustomStyles()
                                    .getStyleFont(Colors.blue.shade900, 15.0),
                              ),
                            ]),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(flex: 10, child: SizedBox(width: 10.0)),
                              Expanded(flex: 18, child: Divider()),
                              Expanded(flex: 10, child: SizedBox(width: 10.0)),
                            ]),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.check_circle,
                                  //darken the icon if it is selected or else give it a different color
                                  color: Colors.greenAccent.shade700),
                              SizedBox(width: 10.0),
                              Text(
                                'Cuidamos tu vehículo',
                                textAlign: TextAlign.center,
                                style: CustomStyles()
                                    .getStyleFont(Colors.blue.shade900, 15.0),
                              ),
                            ]),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(flex: 10, child: SizedBox(width: 10.0)),
                              Expanded(flex: 18, child: Divider()),
                              Expanded(flex: 10, child: SizedBox(width: 10.0)),
                            ]),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.check_circle,
                                  //darken the icon if it is selected or else give it a different color
                                  color: Colors.greenAccent.shade700),
                              SizedBox(width: 10.0),
                              Text(
                                'Protegemos tu vida  ',
                                textAlign: TextAlign.center,
                                style: CustomStyles()
                                    .getStyleFont(Colors.blue.shade900, 15.0),
                              ),
                            ]),
                      ],
                    ),
                  ),
                  Text(
                    'Nota: en un plazo de 24 horas\nse consignará el valor solicitado\n a la cuenta bancaria inscrita en la app\n\n Términos y condiciones',
                    textAlign: TextAlign.center,
                    style:
                        CustomStyles().getStyleFont(Colors.blue.shade900, 12.0),
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
                        'Solicitar retiro',
                        style: GoogleFonts.openSans(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                      ),
                      onPressed: () async {
                        //await sendAndRetrieveMessage();
                        Configuracion config =
                            await DatabaseService().configuracion;
                        NotificadorEmail notificador = NotificadorEmail(
                            asunto: "Mecanico - Solicitud de retiro",
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
                    height: 50.0,
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  String expresionRegular(double numero) {
    NumberFormat f = new NumberFormat("#,###.0#", "es_US");
    String result = f.format(numero);
    return result;
  }
}
