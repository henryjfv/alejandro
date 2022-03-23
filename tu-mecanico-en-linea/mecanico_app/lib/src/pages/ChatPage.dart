import 'package:flutter/material.dart';
import 'package:mecanico_app/src/utils/AppBarConfig.dart';
import 'package:mecanico_app/src/utils/Colors.dart';
import 'package:mecanico_app/src/utils/Decorations.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Widget> itemsLista = [
    Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Hola que tanto te demoras'),
          ),
        ),
      ),
    ),
    Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No mucho señora'),
          ),
        ),
      ),
    ),
  ];
  TextEditingController _textoController;
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    _textoController = TextEditingController(text: '');

    super.initState();
  }

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
              decoration: fondoCurvoGradient),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 8.0, 8.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      height: size.width * 0.9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                              color: Colors.lightBlue,
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      'images/mecanico.jpg',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: new ListView(
                              controller: controller,
                              children: itemsLista,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _textoController,
                                        decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(50.0),
                                              ),
                                            ),
                                            filled: true,
                                            hintStyle: new TextStyle(
                                                color: Colors.grey[800]),
                                            fillColor: Colors.white70),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.send),
                                        onPressed: () {
                                          addChildrenList(
                                              _textoController.text.trim());
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Servicio completado con exito",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xff0F6F94),
                  onPressed: () {
                    print("Hola Raised Button");
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Presiona el boton cuando el servicio halla culminado",
                    style: TextStyle(color: Color(0xff0F6F94)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _seleccionMenu(int value) {}

  addChildrenList(String text) {
    setState(() {
      itemsLista.add(
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text),
              ),
            ),
          ),
        ),
      );
      _textoController.clear();
    });
    //controller.jumpTo(controller.position.maxScrollExtent);
    controller.animateTo(controller.offset + 60,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }
}
/*  decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ), */
