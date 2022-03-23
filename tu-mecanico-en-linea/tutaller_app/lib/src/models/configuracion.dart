class Configuracion {
  int consecutivo;
  int consecutivoPagos;
  String emailContacto;
  List ciudades;
  double distanciaBusqueda;
  String horarioTalleres;
  String llavePrvWompi;
  String llavePubWompi;
  String mensajeWhatsappSoporte;
  String telefonoWhatsAppSoporte;
  String valorDomicilioMecanicos;
  String urlContratoTaller;
  String urlContratoMecanico;

  Configuracion(
      {this.consecutivo,
      this.emailContacto,
      this.ciudades,
      this.distanciaBusqueda,
      this.consecutivoPagos,
      this.horarioTalleres,
      this.llavePrvWompi,
      this.llavePubWompi,
      this.mensajeWhatsappSoporte,
      this.telefonoWhatsAppSoporte,
      this.valorDomicilioMecanicos,
      this.urlContratoTaller,
      this.urlContratoMecanico});
}
