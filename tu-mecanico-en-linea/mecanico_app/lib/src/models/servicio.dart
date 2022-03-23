import 'package:mecanico_app/src/pages/shared/enums.dart';

class Servicio {
  String idUsuario;
  String idTaller;
  String nombreTaller;
  String fecha;
  String hora;
  String ciudad;
  EstadoServicio estado;
  String descripcion;
  String codigo;
  String nombreUsuario;
  String telefonoUsuario;
  String tipoDeServicio;
  bool confirmado;
  String urlImagenTaller;
  double valorServicio;
  String direccion;

  Servicio(
      {this.idUsuario,
      this.idTaller,
      this.nombreTaller,
      this.fecha,
      this.hora,
      this.ciudad,
      this.estado,
      this.descripcion,
      this.codigo,
      this.tipoDeServicio,
      this.nombreUsuario,
      this.confirmado,
      this.urlImagenTaller,
      this.valorServicio,
      this.direccion});
}
