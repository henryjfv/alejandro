import 'package:flutter/material.dart';
import 'package:tutaller_app/src/utils/firebase_auth.dart';

class MenuToolbar {
  _seleccionMenu(int value) async {
    switch (value) {
      case 0:
        await AuthProvider().logOut();
        break;
    }

    print(value);
  }

  Widget menuToolbarLight() {
    return Align(
      alignment: FractionalOffset.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 0.0, top: 25),
        child: PopupMenuButton<int>(
          icon: Icon(
            Icons.menu,
            color: Color(0xff203387),
            size: 28.0,
          ),
          onSelected: (value) => _seleccionMenu(value),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 0,
              child: Text('Cerrar session'),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuToolbarDark() {
    return Align(
      alignment: FractionalOffset.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 0.0, top: 25),
        child: PopupMenuButton<int>(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 28.0,
          ),
          onSelected: (value) => _seleccionMenu(value),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 0,
              child: Text('Cerrar session'),
            ),
          ],
        ),
      ),
    );
  }
}
