import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/FormularioPerfil.dart';

import 'package:mecanico_app/src/utils/DatabaseService.dart';

import 'package:mecanico_app/src/utils/utils.dart';
import 'package:provider/provider.dart';

class PerfilUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String idUser = FirebaseAuth.instance.currentUser.uid.toString();
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        actions: AccionesToolbar(context: context).getAcciones(),
      ),
      body: StreamProvider<UserData>.value(
          value: DatabaseService(uid: idUser).userData,
          child: SingleChildScrollView(
              child: Stack(
            children: [
              Container(
                height: size.height * .8,
                width: double.infinity,
                decoration: fondoCurvoGradient,
              ),
              FormularioPerfil(),
            ],
          ))),
    );
  }
}
