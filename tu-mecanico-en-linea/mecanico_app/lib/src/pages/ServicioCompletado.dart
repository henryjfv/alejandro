import 'package:flutter/material.dart';
import 'package:mecanico_app/src/utils/styles.dart';
import 'package:mecanico_app/src/utils/utils.dart';

class ServicioCompletado extends StatelessWidget {
  const ServicioCompletado({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        actions: AccionesToolbar(context: context).getAcciones(),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .6,
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
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                child: Stack(
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 8.0, 2.0),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Mecánico',
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Julian Armando',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color(0XFF329D9C),
                                    ),
                                  ),
                                  Text(
                                    'Calles',
                                    style: TextStyle(
                                      color: Color(0XFF329D9C),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    'images/mecanico.jpg',
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Image.asset('images/Check.png'),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                'Era lo que esperaba',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Image.asset('images/Check.png'),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                'Me solucionó el problema',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Image.asset('images/Check.png'),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                '¡Gracias por todo!',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Servicio completado",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xff0F6F94),
                          onPressed: () {
                            print("Hola Raised Button");
                          },
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            "No estoy conforme con el servicio",
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.white),
                          ),
                          color: Color(0xffFF7700),
                          onPressed: () {
                            print("Hola Raised Button");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Recuerda que cualquier duda puedes escribirnos a tumecanicoenlinnea2020@gmail.com',
                style: CustomStyles().getStyleFont(Colors.teal, 12.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
