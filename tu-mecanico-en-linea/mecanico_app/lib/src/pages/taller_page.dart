import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/registro-servicio.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TallerPage extends StatefulWidget {
  final UserTaller mTaller;
  TallerPage({Key key, this.mTaller}) : super(key: key);

  @override
  _TallerPageState createState() => _TallerPageState();
}

class _TallerPageState extends State<TallerPage> {
  String tallerNombre = '';
  String idTaller = '';

  @override
  void initState() {
    tallerNombre = widget.mTaller.nombre.toString();
    idTaller = widget.mTaller.uid.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String idUser = FirebaseAuth.instance.currentUser.uid.toString();

    return StreamProvider<UserData>.value(
        value: DatabaseService(uid: idUser).userData,
        child: RegistroServicio(taller: widget.mTaller));
  }
}
