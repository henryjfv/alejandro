import 'package:tutaller_app/src/pages/shared/enums.dart';

class Cartera{
  String idServicioPrestado;
  double valor;
  EstadoCartera estado;
  TipoCuenta cuenta;

  Cartera({this.idServicioPrestado,this.valor,this.estado,this.cuenta});
}