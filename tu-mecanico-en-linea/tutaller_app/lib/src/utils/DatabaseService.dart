import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:tutaller_app/src/models/cartera.dart';
import 'package:tutaller_app/src/models/configuracion.dart';
import 'package:tutaller_app/src/models/domicilio.dart';
import 'package:tutaller_app/src/models/servicio.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'package:tutaller_app/src/pages/shared/enums.dart';
import 'package:tutaller_app/src/pages/shared/singleTone.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference mecanicosCollection =
      FirebaseFirestore.instance.collection('mecanicos');
  final CollectionReference talleresCollection =
      FirebaseFirestore.instance.collection('talleres');
  final CollectionReference serviciosCollection =
      FirebaseFirestore.instance.collection('servicios');
  final CollectionReference domiciliosCollection =
      FirebaseFirestore.instance.collection('domicilios');
  final CollectionReference usuarioCollection =
      FirebaseFirestore.instance.collection('usuarios_clientes');
  final CollectionReference configuracionCollection =
      FirebaseFirestore.instance.collection('parametros');
  final CollectionReference carteraCollection =
      FirebaseFirestore.instance.collection('carteras');

  Future<void> updateMecanicoData(UserMecanico user) async {
    return await mecanicosCollection.doc(uid).set({
      'uid': user.uid,
      'email': user.email,
      'password': user.password,
      'nombre': user.nombre,
      'cedula': user.cedula,
      'celular': user.celular,
      'direccion': user.direccion,
      'ciudad': user.ciudad,
      'esMecanicoTecnico': user.esMecanicoTecnico,
      'marcas': user.marcas,
      'tieneTransporte': user.tieneTransporte,
      'tieneHerramientas': user.tieneHerramientas,
      'cuentaBancaria': user.cuentaBancaria,
      'banco': user.banco,
      'cartera': user.cartera ?? 0,
      'fcmToken': user.fcmToken ?? '',
      'isLogin': user.isLogin ?? true,
      'urlImagen': user.urlImagen ?? '',
    });
  }

  Future<void> updateTallerData(UserTaller user) async {
    return await talleresCollection.doc(uid).set({
      'uid': user.uid,
      'nit': user.nit,
      'email': user.email,
      'password': user.password,
      'nombre': user.nombre,
      'propietario': user.propietario,
      'celular': user.celular,
      'direccion': user.direccion,
      'ciudad': user.ciudad,
      'telefono1': user.telefono1,
      'telefono2': user.telefono2,
      'servicios': user.servicios,
      'marcas': user.marcas,
      'tieneHerramientas': user.tieneHerramientas,
      'cuentaBancaria': user.cuentaBancaria,
      'banco': user.banco,
      'latitud': user.latitud,
      'longitud': user.longitud,
      'cartera': user.cartera ?? 0,
      'fcmToken': user.fcmToken ?? '',
      'isLogin': user.isLogin ?? true,
      'urlImagen': user.urlImagen ?? '',
    });
  }

  Future<void> updateDomicilioData(Domicilio domicilio) async {
    return await domiciliosCollection
        .doc(domicilio.idUsuario)
        .collection("domicilios")
        .doc(domicilio.id)
        .set({
      'idUsuario': domicilio.idUsuario,
      'idMecanico': domicilio.idMecanico,
      'nombreMecanico': domicilio.nombreMecanico,
      'ciudadMunicipio': domicilio.ciudadMunicipio,
      'ubicacionActual': domicilio.ubicacionActual,
      'barrio': domicilio.barrio,
      'marcaCarro': domicilio.marcaCarro,
      'modelo': domicilio.modelo,
      'kilometraje': domicilio.kilometraje,
      'descripcion': domicilio.descripcion,
      'fecha': domicilio.fecha,
      'estado': EnumToString.convertToString(domicilio.estado),
      'nombreUsuario': domicilio.nombreUsuario,
      'telefonoUsuario': domicilio.telefonoUsuario,
      'latitud': domicilio.latitud ?? 0,
      'longitud': domicilio.longitud ?? 0,
      'referenciaPago': domicilio.referenciaPago ?? 0,
      'domicilioPagado': domicilio.domicilioPagado ?? false,
      'urlImagenMecanico': domicilio.urlImagenMecanico ?? '',
    });
  }

  Future<void> updateEstadoServicio(Servicio servicio) async {
    return await serviciosCollection
        .doc(servicio.idUsuario)
        .collection("servicios")
        .doc(servicio.codigo)
        .update({
      'estado': EnumToString.convertToString(servicio.estado),
      'valorServicio': servicio.valorServicio ?? double.parse("0"),
    });
  }

  Future<void> updateEstadoDomicilio(Domicilio domicilio) async {
    return await domiciliosCollection
        .doc(domicilio.idUsuario)
        .collection("domicilios")
        .doc(domicilio.id)
        .update({
      'estado': EnumToString.convertToString(domicilio.estado),
      'idMecanico': domicilio.estado == EstadoDomicilio.Creado
          ? null
          : domicilio.idMecanico
    });
  }

  Future<void> updateTokenUserData(String id, String token) async {
    bool usuarioTaller = await esUsuarioTaller;
    if (usuarioTaller) {
      return await talleresCollection.doc(id).update({'fcmToken': token});
    } else {
      return await mecanicosCollection.doc(id).update({'fcmToken': token});
    }
  }

  Future<void> updateIsLoginUserData(String id, bool isLogin) async {
    List<DocumentSnapshot> documentList;
    documentList =
        (await mecanicosCollection.where("uid", isEqualTo: id).get()).docs;
    bool usuarioTaller = documentList.isEmpty;
    if (usuarioTaller) {
      return await talleresCollection.doc(id).update({'isLogin': isLogin});
    } else {
      return await mecanicosCollection.doc(id).update({'isLogin': isLogin});
    }
  }

  // brew list from snapshot
  UserTaller _userTallerFromSnapshot(DocumentSnapshot snapshot) {
    return UserTaller(
      uid: uid,
      email: snapshot.data()["email"],
      password: snapshot.data()['password'],
      nombre: snapshot.data()['nombre'],
      nit: snapshot.data()['nit'],
      propietario: snapshot.data()['propietario'],
      celular: snapshot.data()['celular'],
      direccion: snapshot.data()['direccion'],
      ciudad: snapshot.data()['ciudad'],
      telefono1: snapshot.data()['telefono1'],
      telefono2: snapshot.data()['telefono2'],
      servicios: snapshot.data()['servicios'],
      marcas: snapshot.data()['marcas'],
      tieneHerramientas: snapshot.data()['tieneHerramientas'],
      cuentaBancaria: snapshot.data()['cuentaBancaria'],
      banco: snapshot.data()['banco'],
      latitud: snapshot.data()['latitud'],
      longitud: snapshot.data()['longitud'],
      cartera: snapshot.data()['cartera'] ?? 0,
      fcmToken: snapshot.data()['fcmToken'] ?? '',
      isLogin: snapshot.data()['isLogin'] ?? true,
      urlImagen: snapshot.data()['urlImagen'] ?? '',
    );
  }

  // user data from snapshots
  UserMecanico _userMecanicoFromSnapshot(DocumentSnapshot snapshot) {
    print(snapshot.data());
    print(snapshot.get('nombre'));
    return UserMecanico(
      uid: uid,
      email: snapshot.data()["email"],
      password: snapshot.data()['password'],
      nombre: snapshot.data()['nombre'],
      cedula: snapshot.data()['cedula'],
      celular: snapshot.data()['celular'],
      direccion: snapshot.data()['direccion'],
      ciudad: snapshot.data()['ciudad'],
      esMecanicoTecnico: snapshot.data()['esMecanicoTecnico'],
      marcas: snapshot.data()['marcas'],
      tieneTransporte: snapshot.data()['tieneTransporte'],
      tieneHerramientas: snapshot.data()['tieneHerramientas'],
      cuentaBancaria: snapshot.data()['cuentaBancaria'],
      banco: snapshot.data()['banco'],
      cartera: snapshot.data()['cartera'] ?? 0,
      fcmToken: snapshot.data()['fcmToken'] ?? '',
      isLogin: snapshot.data()['isLogin'] ?? true,
      urlImagen: snapshot.data()['urlImagen'] ?? '',
    );
  }

  UserCliente _userClienteFromSnapshot(DocumentSnapshot snapshot) {
    return UserCliente(
      uid: uid,
      nombres: snapshot.data()['nombres'],
      email: snapshot.data()["email"],
      telefono: snapshot.data()['telefono'],
      fcmToken: snapshot.data()['fcmToken'] ?? '',
      urlImagen: snapshot.data()['urlImagen'] ?? '',
    );
  }

  Configuracion _configuracionFromSnapshot(DocumentSnapshot snapshot) {
    var configuracion = Configuracion(
        consecutivo: snapshot.data()['consecutivo'],
        emailContacto: snapshot.data()['emailContacto'],
        ciudades: snapshot.data()['ciudades'],
        distanciaBusqueda: snapshot.data()['distanciaBusqueda'],
        consecutivoPagos: snapshot.data()['consecutivoPagos'],
        horarioTalleres: snapshot.data()['horarioTalleres'],
        llavePrvWompi: snapshot.data()['llavePrvWompi'],
        llavePubWompi: snapshot.data()['llavePubWompi'],
        mensajeWhatsappSoporte: snapshot.data()['mensajeWhatsappSoporte'],
        telefonoWhatsAppSoporte: snapshot.data()['telefonoWhatsAppSoporte'],
        valorDomicilioMecanicos: snapshot.data()['valorDomicilioMecanicos'],
        urlContratoTaller: snapshot.data()['urlContratoTaller'],
        urlContratoMecanico: snapshot.data()['urlContratoMecanico']);
    return configuracion;
  }

  List<Servicio> _serviciosListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Servicio(
        idUsuario: doc.data()['idUsuario'] ?? '',
        idTaller: doc.data()['idTaller'] ?? '',
        fecha: doc.data()['fecha'] ?? '',
        hora: doc.data()['hora'] ?? '',
        ciudad: doc.data()['ciudad'] ?? '',
        estado: (doc.data()['estado'] ?? '') != ''
            ? EnumToString.fromString(
                EstadoServicio.values, doc.data()['estado'])
            : EstadoServicio.Creado,
        descripcion: doc.data()['descripcion'] ?? '',
        codigo: doc.data()['codigo'] ?? '',
        nombreUsuario: doc.data()['nombreUsuario'] ?? '',
        telefonoUsuario: doc.data()['telefonoUsuario'] ?? '',
        tipoDeServicio: doc.data()['tipoDeServicio'] ?? '',
        confirmado: doc.data()['confirmado'] ?? false,
        urlImagenTaller: doc.data()['urlImagenTaller'] ?? '',
        valorServicio: doc.data()['valorServicio'] ?? double.parse("0"),
      );
    }).toList();
  }

  List<Domicilio> _domiciliosListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Domicilio(
        id: doc.id.toString(),
        idUsuario: doc.data()['idUsuario'] ?? '',
        idMecanico: doc.data()['idMecanico'] ?? '',
        fecha: doc.data()['fecha'] ?? '',
        ciudadMunicipio: doc.data()['ciudadMunicipio'] ?? '',
        ubicacionActual: doc.data()['ubicacionActual'] ?? '',
        barrio: doc.data()['barrio'] ?? '',
        marcaCarro: doc.data()['marcaCarro'] ?? '',
        modelo: doc.data()['modelo'] ?? '',
        kilometraje: doc.data()['kilometraje'] ?? '',
        estado: (doc.data()['estado'] ?? '') != ''
            ? EnumToString.fromString(
                EstadoDomicilio.values, doc.data()['estado'])
            : EstadoDomicilio.Creado,
        descripcion: doc.data()['descripcion'] ?? '',
        nombreUsuario: doc.data()['nombreUsuario'] ?? '',
        telefonoUsuario: doc.data()['telefonoUsuario'] ?? '',
        latitud: doc.data()['latitud'] ?? 0,
        longitud: doc.data()['longitud'] ?? 0,
        referenciaPago: doc.data()['referenciaPago'] ?? 0,
        domicilioPagado: doc.data()['domicilioPagado'] ?? false,
        urlImagenMecanico: doc.data()['urlImagenMecanico'] ?? '',
      );
    }).toList();
  }

  Servicio _serviciosListFromSnapshot2(QueryDocumentSnapshot doc) {
    return Servicio(
      idUsuario: doc.data()['idUsuario'] ?? '',
      idTaller: doc.data()['idTaller'] ?? '',
      fecha: doc.data()['fecha'] ?? '',
      hora: doc.data()['hora'] ?? '',
      ciudad: doc.data()['ciudad'] ?? '',
      estado: (doc.data()['estado'] ?? '') != ''
          ? EnumToString.fromString(EstadoServicio.values, doc.data()['estado'])
          : EstadoServicio.Creado,
      descripcion: doc.data()['descripcion'] ?? '',
      codigo: doc.data()['codigo'] ?? '',
      tipoDeServicio: doc.data()['tipoDeServicio'] ?? '',
      confirmado: doc.data()['confirmado'] ?? false,
      urlImagenTaller: doc.data()['urlImagenTaller'] ?? '',
      valorServicio: doc.data()['valorServicio'] ?? double.parse("0"),
    );
  }

  Future<bool> usuarioTallerExiste(String email) async {
    return (await talleresCollection.where("email", isEqualTo: email).get())
        .docs
        .isNotEmpty;
  }

  Future<bool> usuarioMecanicoExiste(String email) async {
    return (await mecanicosCollection.where("email", isEqualTo: email).get())
        .docs
        .isNotEmpty;
  }

  Future<Configuracion> get configuracion {
    return configuracionCollection
        .doc("configuracion")
        .snapshots()
        .map(_configuracionFromSnapshot)
        .first;
  }

  // get user doc stream
  Stream<UserTaller> get tallerData {
    return talleresCollection.doc(uid).snapshots().map(_userTallerFromSnapshot);
  }

  // get user doc stream
  Stream<UserMecanico> get mecanicoData {
    return mecanicosCollection
        .doc(uid)
        .snapshots()
        .map(_userMecanicoFromSnapshot);
  }

  Future<bool> get esUsuarioTaller async {
    List<DocumentSnapshot> documentList;
    documentList =
        (await mecanicosCollection.where("uid", isEqualTo: uid).get()).docs;
    return documentList.isEmpty;
  }

  Future<List<Servicio>> get servicios async {
    //return serviciosCollection.snapshots().map(_serviciosListFromSnapshot);
    return (await serviciosCollection
            .doc()
            .collection("servicios")
            .where("idTaller", isEqualTo: uid)
            .get())
        .docs
        .map(_serviciosListFromSnapshot2)
        .toList();
  }

  Stream<List<Servicio>> get servicios2 {
    return FirebaseFirestore.instance
        .collectionGroup('servicios')
        .where("idTaller", isEqualTo: uid)
        .orderBy("codigo", descending: true)
        .snapshots()
        .map(_serviciosListFromSnapshot);
  }

  Stream<List<Servicio>> servicioByCodigo(String codigo) {
    return FirebaseFirestore.instance
        .collectionGroup('servicios')
        .where("codigo", isEqualTo: codigo)
        .snapshots()
        .map(_serviciosListFromSnapshot);
  }

  Stream<List<Servicio>> get serviciosActivos {
    return FirebaseFirestore.instance
        .collectionGroup('servicios')
        .where("idTaller", isEqualTo: uid)
        .orderBy("codigo", descending: true)
        .where("estado",
            isEqualTo: EnumToString.convertToString(EstadoServicio.Creado))
        .snapshots()
        .map(_serviciosListFromSnapshot);
  }

  Future<int> get cantidadServiciosRealizados {
    return FirebaseFirestore.instance
        .collectionGroup('servicios')
        .where("idTaller", isEqualTo: uid)
        .orderBy("codigo", descending: true)
        .where("estado",
            isEqualTo: EnumToString.convertToString(EstadoServicio.Terminado))
        .snapshots()
        .map(_serviciosListFromSnapshot)
        .length;
  }

  Stream<List<Domicilio>> get domicilios {
    return FirebaseFirestore.instance
        .collectionGroup('domicilios')
        .where("idMecanico", isEqualTo: uid)
        .snapshots()
        .map(_domiciliosListFromSnapshot);
  }

  Stream<List<Domicilio>> getDomiciliosByEstado(
      String idMecanico, String estado) {
    return FirebaseFirestore.instance
        .collectionGroup('domicilios')
        .where("idMecanico", isEqualTo: uid)
        .where("estado", isEqualTo: estado)
        .snapshots()
        .map(_domiciliosListFromSnapshot);
  }

  Stream<List<Domicilio>> getDomiciliosActivos(String idCliente) {
    return FirebaseFirestore.instance
        .collectionGroup('domicilios')
        .where("estado",
            isEqualTo: EnumToString.convertToString(EstadoDomicilio.Creado))
        .snapshots()
        .map(_domiciliosListFromSnapshot);
  }

  Stream<List<Domicilio>> getDomiciliosRealizados(String idMecanico) {
    return FirebaseFirestore.instance
        .collectionGroup('domicilios')
        .where("estado",
            isEqualTo: EnumToString.convertToString(EstadoDomicilio.Terminado))
        .where("idMecanico", isEqualTo: idMecanico)
        .snapshots()
        .map(_domiciliosListFromSnapshot);
  }

  Stream<UserCliente> getUsuarioCliente(String idCliente) {
    return usuarioCollection
        .doc(idCliente)
        .snapshots()
        .map(_userClienteFromSnapshot);
  }

  Future<void> addCartera(Cartera cartera) async {
    return await carteraCollection
        .doc(uid)
        .collection("carteras")
        .doc(cartera.idServicioPrestado)
        .set({
      'idServicioPrestado': cartera.idServicioPrestado,
      'valor': cartera.valor,
      'EstadoCartera': EnumToString.convertToString(cartera.estado),
      'TipoCuenta': EnumToString.convertToString(cartera.cuenta),
    });
  }

  Future<void> notificarCliente(
      String idCliente, String titulo, String contenido) async {
    var doc = await usuarioCollection.doc(idCliente).snapshots().first;
    var token = doc.data()['fcmToken'] ?? '';
    var isLogin = doc.data()['isLogin'] ?? false;
    if (token != null && token != "" && isLogin) {
      Singleton().notificador.sendAndRetrieveMessage(token, titulo, contenido);
    }

    return null;
  }
}
