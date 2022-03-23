import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/MecanicoPage.dart';

import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PadreMecanicoPage extends StatefulWidget {
  PadreMecanicoPage({Key key}) : super(key: key);

  @override
  _PadreMecanicoPageState createState() => _PadreMecanicoPageState();
}

class _PadreMecanicoPageState extends State<PadreMecanicoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String idUser = FirebaseAuth.instance.currentUser.uid.toString();

    return StreamProvider<UserData>.value(
        value: DatabaseService(uid: idUser).userData, child: MecanicoPage());
  }
}
