import 'package:flutter/material.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class WrapperData extends StatelessWidget {
  Widget page;
  WrapperData({Key key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    // return either the Home or Authenticate widget
    if (user == null) {
      return LoginPage();
      //return MapPage();
    } else {
      return page;
    }
  }
}
