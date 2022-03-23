class Configuracion {
  int consecutivo;
  int consecutivoPagos;
  String emailContacto;
  List ciudades;
  String horarioTalleres;
  String llavePrvWompi;
  String llavePubWompi;
  String mensajeWhatsappSoporte;
  String mensajeWhatsappAyuda;
  String telefonoWhatsAppSoporte;
  String telefonoWhatsAppAyuda;
  String valorDomicilioMecanicos;
  String urlPagos;

  Configuracion(
      {this.consecutivo,
      this.consecutivoPagos,
      this.emailContacto,
      this.ciudades,
      this.horarioTalleres,
      this.llavePrvWompi,
      this.llavePubWompi,
      this.mensajeWhatsappSoporte,
      this.mensajeWhatsappAyuda,
      this.telefonoWhatsAppSoporte,
      this.telefonoWhatsAppAyuda,
      this.valorDomicilioMecanicos,
      this.urlPagos});
}
