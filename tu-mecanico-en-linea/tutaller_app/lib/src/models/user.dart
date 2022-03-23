class UserApp {
  String uid;

  UserApp({this.uid});
}

class UserTaller {
  String uid;
  final String email;
  final String password;
  final String nombre;
  final String nit;
  final String propietario;
  String direccion;
  final int celular;
  final int telefono1;
  final int telefono2;
  final String servicios;
  final String ciudad;
  final String marcas;
  final bool tieneHerramientas;
  String cuentaBancaria;
  String banco;
  double latitud;
  double longitud;
  double cartera;
  String fcmToken;
  bool isLogin;
  String urlImagen;

  UserTaller(
      {this.uid,
      this.email,
      this.nombre,
      this.password,
      this.propietario,
      this.direccion,
      this.celular,
      this.telefono1,
      this.telefono2,
      this.servicios,
      this.ciudad,
      this.marcas,
      this.tieneHerramientas,
      this.nit,
      this.latitud,
      this.longitud,
      this.cuentaBancaria,
      this.banco,
      this.cartera,
      this.fcmToken,
      this.isLogin,
      this.urlImagen});
}

class UserMecanico {
  String uid;
  final String email;
  final String password;
  final String nombre;
  final String cedula;
  final int celular;
  final String direccion;
  final String ciudad;
  final bool esMecanicoTecnico;
  final String marcas;
  final bool tieneTransporte;
  final bool tieneHerramientas;
  final String cuentaBancaria;
  final String banco;
  final double cartera;
  final String fcmToken;
  bool isLogin;
  String urlImagen;

  UserMecanico(
      {this.uid,
      this.email,
      this.password,
      this.nombre,
      this.cedula,
      this.celular,
      this.direccion,
      this.ciudad,
      this.esMecanicoTecnico,
      this.marcas,
      this.tieneTransporte,
      this.tieneHerramientas,
      this.cuentaBancaria,
      this.banco,
      this.cartera,
      this.fcmToken,
      this.isLogin,
      this.urlImagen});
}

class GoogleUser {
  final String id;
  final String nombre;
  final String email;
  final String fotoUrl;
  GoogleUser({this.id, this.nombre, this.email, this.fotoUrl});
}

class UserCliente {
  final String uid;
  final String nombres;
  final String email;
  final int telefono;
  String fcmToken;
  String urlImagen;

  UserCliente(
      {this.uid,
      this.nombres,
      this.email,
      this.telefono,
      this.fcmToken,
      this.urlImagen});
}
