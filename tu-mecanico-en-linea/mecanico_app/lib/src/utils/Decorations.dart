import 'package:flutter/material.dart';

const Decoration decoracionTitulos = BoxDecoration(
  image: DecorationImage(
      image: AssetImage('images/CardTitulos.png'), fit: BoxFit.fitWidth),
);

const Decoration fondoCurvoGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff001558),
      Color(0xff0F6F94),
    ],
    stops: [0.5, 1.5],
  ),
  borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(70), bottomRight: Radius.circular(70)),
);

const Decoration decoracionCardCurvo = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(
    Radius.circular(20),
  ),
);

const Decoration decoracionCurvaGradientAppBar = BoxDecoration(
  borderRadius: BorderRadius.vertical(
    bottom: Radius.circular(50),
  ),
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff001558), Color(0xff0F6F94)],
    stops: [0.5, 1.5],
  ),
);

const Decoration decoracionBottomSheet = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(50),
    topRight: Radius.circular(50),
  ),
);
