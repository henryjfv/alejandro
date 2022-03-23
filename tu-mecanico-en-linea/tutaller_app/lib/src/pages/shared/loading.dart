import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff0f6f94),
      child: Center(
        child: SpinKitPouringHourglass(
          color: Color(0xff1fc9d0),
          size: 50.0,
        ),
      ),
    );
  }
}
