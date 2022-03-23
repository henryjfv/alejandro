import 'package:mecanico_app/src/pages/shared/enums.dart';

class Domicilio {
  String id;
  String idUsuario;
  String idMecanico;
  String nombreMecanico;
  String ciudadMunicipio;
  String ubicacionActual;
  String barrio;
  String marcaCarro;
  String modelo;
  String kilometraje;
  String descripcion;
  String fecha;
  EstadoDomicilio estado;
  String nombreUsuario;
  String telefonoUsuario;
  double latitud;
  double longitud;
  int referenciaPago;
  bool domicilioPagado;
  String urlImagenMecanico;

  Domicilio(
      {this.id,
      this.idUsuario,
      this.ciudadMunicipio,
      this.ubicacionActual,
      this.barrio,
      this.marcaCarro,
      this.modelo,
      this.kilometraje,
      this.descripcion,
      this.fecha,
      this.estado,
      this.nombreUsuario,
      this.telefonoUsuario,
      this.idMecanico,
      this.nombreMecanico,
      this.latitud,
      this.longitud,
      this.referenciaPago,
      this.domicilioPagado,
      this.urlImagenMecanico});
}
