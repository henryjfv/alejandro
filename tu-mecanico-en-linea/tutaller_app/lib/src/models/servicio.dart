import 'package:tutaller_app/src/pages/shared/enums.dart';

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
      this.nombreUsuario,
      this.telefonoUsuario,
      this.tipoDeServicio,
      this.confirmado,
      this.urlImagenTaller,
      this.valorServicio});
}
