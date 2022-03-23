import 'package:tutaller_app/src/pages/shared/enums.dart';

class Domicilio {
  String id;
  String idUsuario;
  String idMecanico;
  String fecha;
  String ciudadMunicipio;
  String ubicacionActual;
  String barrio;
  String marcaCarro;
  String modelo;
  String kilometraje;
  EstadoDomicilio estado;
  String descripcion;
  String nombreUsuario;
  String nombreMecanico;
  String telefonoUsuario;
  double latitud;
  double longitud;
  int referenciaPago;
  bool domicilioPagado;
  String urlImagenMecanico;

  Domicilio(
      {this.id,
      this.idUsuario,
      this.idMecanico,
      this.fecha,
      this.ciudadMunicipio,
      this.ubicacionActual,
      this.barrio,
      this.marcaCarro,
      this.modelo,
      this.kilometraje,
      this.estado,
      this.descripcion,
      this.nombreUsuario,
      this.telefonoUsuario,
      this.latitud,
      this.longitud,
      this.referenciaPago,
      this.domicilioPagado,
      this.urlImagenMecanico});
}
