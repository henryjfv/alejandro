import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mecanico_app/src/pages/ServiciosTomadosPage.dart';
import 'package:mecanico_app/src/pages/TengoUnProblemaPage.dart';
import 'package:mecanico_app/src/pages/WrapperData.dart';
import 'package:mecanico_app/src/pages/home_page.dart';
import 'package:mecanico_app/src/pages/perfil_usuario.dart';
import 'package:mecanico_app/src/utils/firebase_auth.dart';

class AccionesToolbar {
  BuildContext context;
  AccionesToolbar({this.context});

  List<PopupMenuButton<int>> getAcciones() {
    return [
      PopupMenuButton<int>(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
          size: 28.0,
        ),
        onSelected: (value) async {
          switch (value) {
            case 0:
              Navigator.pushReplacement(
                this.context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                this.context,
                CupertinoPageRoute(
                  builder: (context) => WrapperData(
                    page: PerfilUsuario(),
                  ) /*  WrapperDomicilio() */,
                ),
              );
              break;
            case 2:
              Navigator.push(
                this.context,
                CupertinoPageRoute(
                  builder: (context) => WrapperData(
                    page: ServiciosTomados(),
                  ) /*  WrapperDomicilio() */,
                ),
              );
              break;
            case 3:
              Navigator.push(
                this.context,
                CupertinoPageRoute(
                  builder: (context) =>
                      TengoUnProblema() /*  WrapperDomicilio() */,
                ),
              );
              break;
            case 4:
              await AuthProvider().logOut(context);
              break;
            default:
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          const PopupMenuItem<int>(
            value: 0,
            child: Text('Inicio / Servicios'),
          ),
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Perfil'),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text('Historial de servicios'),
          ),
          const PopupMenuItem<int>(
            value: 3,
            child: Text('Ayuda'),
          ),
          const PopupMenuItem<int>(
            value: 4,
            child: Text('Salir'),
          ),
        ],
      ),
    ];
  }
}
