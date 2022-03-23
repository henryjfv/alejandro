import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';
import 'map_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return LoginPage();
      //return MapPage();
    } else {
      return MapPage();
      //return MapPage();
    }
  }
}
