import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/home_page.dart';

import 'login_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return LoginPage();
      //return MapPage();
    } else {
      return HomePage(title: 'Tu Taller En línea');
      //return MapPage();
    }
  }
}
