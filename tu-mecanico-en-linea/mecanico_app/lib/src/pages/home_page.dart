import 'package:flutter/material.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';
import 'package:mecanico_app/src/pages/wrapper.dart';
import 'package:mecanico_app/src/providers/push_notifications_provider.dart';
import 'package:mecanico_app/src/utils/AppBarConfig.dart';
import 'package:mecanico_app/src/utils/Colors.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:flutter/cupertino.dart';

import 'wrapperDomicilio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Singleton().notificador.messageStream.listen((argumento) {
      /* showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: ListTile(
                title: Text(
                  'Tu Mecánico En Línea',
                  style: CustomStyles().getStyleFontWithFontWeight(
                      Colors.black, 18.0, FontWeight.bold),
                ),
                subtitle: Text(argumento ?? ""),
              ),
            );
          }); */
    });
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        actions: AccionesToolbar(context: context).getAcciones(),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff001558), Color(0xff0F6F94)],
                  stops: [0.5, 1.5],
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '¿Que falla presenta tu vehículo?',
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              margin: EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      primary: false,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        WrapperDomicilio() /*  */,
                                  ));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/no-arranca.png'),
                                Text('Mi carro no prende',
                                    style: CustomStyles()
                                        .getStyleFontWithFontWeight(
                                            Colors.black,
                                            15.0,
                                            FontWeight.bold)),
                                Text(
                                  'Un mecánico ira a tu ubicación',
                                  style: CustomStyles()
                                      .getStyleFont(Colors.black, 10.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Singleton().tipoEvento = "Mi carro se calienta";
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Wrapper()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/se-calienta.png'),
                                Text('Se calienta',
                                    style: CustomStyles()
                                        .getStyleFontWithFontWeight(
                                            Colors.black,
                                            15.0,
                                            FontWeight.bold)),
                                Text(
                                  'Te pondremos en contacto con el taller mas cercano',
                                  style: CustomStyles()
                                      .getStyleFont(Colors.black, 10.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Singleton().tipoEvento = "Mi carro echa humo";
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Wrapper()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/echa-humo.png',
                                ),
                                Text('Echa humo',
                                    style: CustomStyles()
                                        .getStyleFontWithFontWeight(
                                            Colors.black,
                                            15.0,
                                            FontWeight.bold)),
                                Text(
                                  'Te pondremos en contacto con el taller mas cercano',
                                  style: CustomStyles()
                                      .getStyleFont(Colors.black, 10.0),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Singleton().tipoEvento = "Mi carro se apaga";
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Wrapper()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/se-apaga.png',
                                ),
                                Text('Se apaga',
                                    style: CustomStyles()
                                        .getStyleFontWithFontWeight(
                                            Colors.black,
                                            15.0,
                                            FontWeight.bold)),
                                Text(
                                  'Te pondremos en contacto con el taller mas cercano',
                                  style: CustomStyles()
                                      .getStyleFont(Colors.black, 10.0),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Singleton().tipoEvento =
                                  "Mi carro pierde potencia";
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Wrapper()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/pierde-potencia.png',
                                ),
                                Text('Pierde potencia',
                                    style: CustomStyles()
                                        .getStyleFontWithFontWeight(
                                            Colors.black,
                                            15.0,
                                            FontWeight.bold)),
                                Text(
                                  'Te pondremos en contacto con el taller mas cercano',
                                  style: CustomStyles()
                                      .getStyleFont(Colors.black, 10.0),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Singleton().tipoEvento =
                                  "Mi carro presenta otra falla";
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Wrapper()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/no-idea.png',
                                ),
                                Text('Otra falla',
                                    style: CustomStyles()
                                        .getStyleFontWithFontWeight(
                                            Colors.black,
                                            15.0,
                                            FontWeight.bold)),
                                Text(
                                  'Te pondremos en contacto con el taller mas cercano',
                                  style: CustomStyles()
                                      .getStyleFont(Colors.black, 10.0),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
