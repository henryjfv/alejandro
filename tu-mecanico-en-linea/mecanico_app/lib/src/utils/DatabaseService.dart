import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mecanico_app/src/models/Cartera.dart';
import 'package:mecanico_app/src/models/Configuracion.dart';
import 'package:mecanico_app/src/models/domicilio.dart';
import 'package:mecanico_app/src/models/servicio.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/shared/enums.dart';
import 'package:mecanico_app/src/pages/shared/singleTone.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference mecanicosCollection =
      FirebaseFirestore.instance.collection('mecanicos');
  final CollectionReference usuarioCollection =
      FirebaseFirestore.instance.collection('usuarios_clientes');
  final CollectionReference talleresCollection =
      FirebaseFirestore.instance.collection('talleres');
  final CollectionReference configuracionCollection =
      FirebaseFirestore.instance.collection('parametros');
  final CollectionReference carteraCollection =
      FirebaseFirestore.instance.collection('carteras');

  //LISTA DE LOS SERVICIOS A LOS TALLERES
  final CollectionReference serviciosCollection =
      FirebaseFirestore.instance.collection('servicios');
  //FIN LISTA DE TALLERES
  //LISTA DE MECANICOS
  final CollectionReference domiciliosCollection =
      FirebaseFirestore.instance.collection('domicilios');
  //FIN LISTA DE MECANICOS

  Future<void> updateUsuarioData(UserData user) async {
    return await usuarioCollection.doc(uid).set({
      'uid': user.uid,
      'nombres': user.nombres,
      'email': user.email,
      'telefono': user.telefono ?? '',
      'password': user.password ?? '',
      'fcmToken': user.fcmToken ?? '',
      'isLogin': user.isLogin ?? '',
      'urlImage': user.urlImage ?? '',
    });
  }

  Future<void> updatePerfilUserData(
      String id, String nombre, String telefono, String urlImage) async {
    return await usuarioCollection.doc(id).update(
        {'nombres': nombre, 'telefono': telefono, 'urlImage': urlImage});
  }

  Future<void> updateTokenUserData(String id, String token) async {
    return await usuarioCollection.doc(id).update({'fcmToken': token});
  }

  Future<void> updateIsLoginUserData(String id, bool isLogin) async {
    return await usuarioCollection.doc(id).update({'isLogin': isLogin});
  }

  Future<void> addServicioData(Servicio servicio) async {
    return await serviciosCollection
        .doc(uid)
        .collection("servicios")
        .doc(servicio.codigo)
        .set({
      'idUsuario': servicio.idUsuario,
      'idTaller': servicio.idTaller,
      'nombreTaller': servicio.nombreTaller,
      'fecha': servicio.fecha,
      'hora': servicio.hora,
      'ciudad': servicio.ciudad,
      'estado': EnumToString.convertToString(servicio.estado),
      'descripcion': servicio.descripcion,
      'codigo': servicio.codigo,
      'nombreUsuario': servicio.nombreUsuario,
      'telefonoUsuario': servicio.telefonoUsuario,
      'tipoDeServicio': servicio.tipoDeServicio,
      'confirmado': servicio.confirmado,
      'urlImagenTaller': servicio.urlImagenTaller,
      'valorServicio': servicio.valorServicio,
      'direccion': servicio.direccion,
    });
  }

  Future<void> updateEstadoServicioData(Servicio servicio) async {
    return await serviciosCollection
        .doc(uid)
        .collection("servicios")
        .doc(servicio.codigo)
        .update({
      'estado': EnumToString.convertToString(servicio.estado),
      'confirmado': servicio.confirmado
    });
  }

  Future<void> addDomicilioData(Domicilio domicilio) async {
    return await domiciliosCollection
        .doc(uid)
        .collection("domicilios")
        .doc()
        .set({
      'idUsuario': domicilio.idUsuario,
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

  Future<void> updateEstadoDomicilio(Domicilio domicilio) async {
    return await domiciliosCollection
        .doc(domicilio.idUsuario)
        .collection("domicilios")
        .doc(domicilio.id)
        .update({
      'estado': EnumToString.convertToString(domicilio.estado),
    });
  }

  Future<void> updateReferenciaDomicilio(Domicilio domicilio) async {
    return await domiciliosCollection
        .doc(domicilio.idUsuario)
        .collection("domicilios")
        .doc(domicilio.id)
        .update({
      'referenciaPago': domicilio.referenciaPago,
    });
  }

  Future<void> updateEstadoPagoDomicilio(Domicilio domicilio) async {
    return await domiciliosCollection
        .doc(domicilio.idUsuario)
        .collection("domicilios")
        .doc(domicilio.id)
        .update({
      'domicilioPagado': domicilio.domicilioPagado,
    });
  }

  Future<bool> usuarioEsxiste(idUsuario) async {
    return (await usuarioCollection.doc(idUsuario).get()).exists;
  }

  // brew list from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      nombres: snapshot.data()['nombres'],
      email: snapshot.data()["email"],
      telefono: snapshot.data()['telefono'],
      password: snapshot.data()['password'],
      fcmToken: snapshot.data()['fcmToken'] ?? '',
      isLogin: snapshot.data()['isLogin'] ?? '',
      urlImage: snapshot.data()['urlImage'] ?? '',
    );
  }

  Domicilio _domicilioDataFromSnapshot(DocumentSnapshot doc) {
    return Domicilio(
        id: doc.id,
        idUsuario: doc.data()['idUsuario'] ?? '',
        fecha: doc.data()['fecha'] ?? '',
        idMecanico: doc.data()['idMecanico'] ?? '',
        nombreMecanico: doc.data()['nombreMecanico'] ?? '',
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
        urlImagenMecanico: doc.data()['urlImagenMecanico'] ?? '');
  }

  Domicilio _domiciliosListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Domicilio(
            id: doc.id,
            idUsuario: doc.data()['idUsuario'] ?? '',
            fecha: doc.data()['fecha'] ?? '',
            idMecanico: doc.data()['idMecanico'] ?? '',
            nombreMecanico: doc.data()['nombreMecanico'] ?? '',
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
            urlImagenMecanico: doc.data()['urlImagenMecanico'] ?? '');
      }).first;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  List<Domicilio> _domiciliosFutereListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map(_domicilioDataFromSnapshot).toList();
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  List<Servicio> _servicioListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map(_serviciosListFromSnapshot).toList();
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  //QuerySnapshot Devuelve una lista de documentos
  List<Servicio> _serviciosList(QuerySnapshot snapshot) {
    try {
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
          tipoDeServicio: doc.data()['tipoDeServicio'] ?? '',
          nombreUsuario: doc.data()['nombreUsuario'] ?? '',
          confirmado: doc.data()['confirmado'] ?? false,
          urlImagenTaller: doc.data()['urlImagenTaller'] ?? '',
          valorServicio: doc.data()['valorServicio'] ?? double.parse("0"),
          direccion: doc.data()['direccion'] ?? '',
        );
      }).toList();
    } catch (ex) {
      print(ex);
      return null;
    }
  }

//QueryDocumentSnapshot Devuelvue un solo documento

  Servicio _serviciosListFromSnapshot(QueryDocumentSnapshot doc) {
    return Servicio(
      idUsuario: doc.data()['idUsuario'] ?? '',
      idTaller: doc.data()['idTaller'] ?? '',
      nombreTaller: doc.data()['nombreTaller'] ?? '',
      fecha: doc.data()['fecha'] ?? '',
      hora: doc.data()['hora'] ?? '',
      ciudad: doc.data()['ciudad'] ?? '',
      estado: (doc.data()['estado'] ?? '') != ''
          ? EnumToString.fromString(EstadoServicio.values, doc.data()['estado'])
          : EstadoServicio.Creado,
      descripcion: doc.data()['descripcion'] ?? '',
      codigo: doc.data()['codigo'] ?? '',
      tipoDeServicio: doc.data()['tipoDeServicio'] ?? '',
      nombreUsuario: doc.data()['nombreUsuario'] ?? '',
      confirmado: doc.data()['confirmado'] ?? false,
      urlImagenTaller: doc.data()['urlImagenTaller'] ?? '',
      valorServicio: doc.data()['valorServicio'] ?? double.parse("0"),
      direccion: doc.data()['direccion'] ?? '',
    );
  }

  Future<List<Servicio>> get getServicios async {
    return (await serviciosCollection.doc(uid).collection("servicios").get())
        .docs
        .map(_serviciosListFromSnapshot)
        .toList();
  }

  Future<List<Servicio>> get getServiciosActivos async {
    return (await serviciosCollection
            .doc(uid)
            .collection("servicios")
            .where("idTaller", isEqualTo: uid)
            .get())
        .docs
        .map(_serviciosListFromSnapshot)
        .toList();
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usuarioCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<UserTaller>> get tallerData {
    print(talleresCollection.snapshots().map(_userTallerFromSnapshot));
    return talleresCollection.snapshots().map(_userTallerFromSnapshot);
  }

  List<UserTaller> _userTallerFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return UserTaller(
        uid: doc.data()["uid"],
        email: doc.data()["email"],
        password: doc.data()['password'],
        nombre: doc.data()['nombre'],
        nit: doc.data()['nit'],
        propietario: doc.data()['propietario'],
        celular: doc.data()['celular'],
        direccion: doc.data()['direccion'],
        ciudad: doc.data()['ciudad'],
        telefono1: doc.data()['telefono1'],
        telefono2: doc.data()['telefono2'],
        servicios: doc.data()['servicios'],
        marcas: doc.data()['marcas'],
        tieneHerramientas: doc.data()['tieneHerramientas'],
        latitud: doc.data()['latitud'],
        longitud: doc.data()['longitud'],
        urlImagen: doc.data()['urlImagen'],
      );
    }).toList();
  }

  Stream<Domicilio> getDomicilio(String idUsuario, String fecha) {
    return domiciliosCollection
        .doc(idUsuario)
        .collection("domicilios")
        .where("idUsuario", isEqualTo: idUsuario)
        .where("fecha", isEqualTo: fecha)
        .snapshots()
        .map(_domiciliosListFromSnapshot);
  }

  Future<Domicilio> get domicilio async {
    //await FirebaseFirestore.instance.clearPersistence();
    return domiciliosCollection
        .doc(uid)
        .collection("domicilios")
        .where("estado", whereIn: [
          EnumToString.convertToString(EstadoDomicilio.Creado),
          EnumToString.convertToString(EstadoDomicilio.Tomado)
        ])
        .snapshots()
        .map(_domiciliosListFromSnapshot)
        .first;
  }

  Future<List<Domicilio>> getDomicilioUsuario(String idUsuario) {
    try {
      return domiciliosCollection
          .doc(idUsuario)
          .collection("domicilios")
          /*.where("estado", whereIn: [
          EnumToString.convertToString(EstadoServicio.Creado),
          EnumToString.convertToString(EstadoServicio.Tomado)
        ])*/
          .get()
          .asStream()
          .map(_domiciliosFutereListFromSnapshot)
          .first;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<List<Servicio>> getServicioUsuario(String idUsuario) {
    return serviciosCollection
        .doc(idUsuario)
        .collection("servicios")
        /*.where("estado", whereIn: [
          EnumToString.convertToString(EstadoDomicilio.Creado),
          EnumToString.convertToString(EstadoDomicilio.Tomado)
        ])*/
        .get()
        .asStream()
        .map(_servicioListFromSnapshot)
        .first;
  }

  Configuracion _configuracionFromSnapshot(DocumentSnapshot snapshot) {
    return Configuracion(
        consecutivo: snapshot.data()['consecutivo'],
        consecutivoPagos: snapshot.data()['consecutivoPagos'],
        emailContacto: snapshot.data()['emailContacto'],
        ciudades: snapshot.data()['ciudades'],
        horarioTalleres: snapshot.data()['horarioTalleres'],
        llavePrvWompi: snapshot.data()['llavePrvWompi'],
        llavePubWompi: snapshot.data()['llavePubWompi'],
        mensajeWhatsappSoporte: snapshot.data()['mensajeWhatsappSoporte'],
        mensajeWhatsappAyuda: snapshot.data()['mensajeWhatsappAyuda'],
        telefonoWhatsAppSoporte: snapshot.data()['telefonoWhatsAppSoporte'],
        telefonoWhatsAppAyuda: snapshot.data()['telefonoWhatsAppAyuda'],
        valorDomicilioMecanicos: snapshot.data()['valorDomicilioMecanicos'],
        urlPagos: snapshot.data()['urlPagos']);
  }

  Future<void> updateConsecutivoConfig(Configuracion configuracion) async {
    return await configuracionCollection
        .doc('configuracion')
        .update({'consecutivo': configuracion.consecutivo});
  }

  Future<void> updateConsecutivoPagoConfig(Configuracion configuracion) async {
    return await configuracionCollection
        .doc('configuracion')
        .update({'consecutivoPagos': configuracion.consecutivoPagos});
  }

  Future<Configuracion> get configuracion {
    return configuracionCollection
        .doc("configuracion")
        .snapshots()
        .map(_configuracionFromSnapshot)
        .first;
  }

  Future<void> addCartera(Cartera cartera, String idMecanido) async {
    return await carteraCollection
        .doc(idMecanido)
        .collection("carteras")
        .doc(cartera.idServicioPrestado)
        .set({
      'idServicioPrestado': cartera.idServicioPrestado,
      'valor': cartera.valor,
      'EstadoCartera': EnumToString.convertToString(cartera.estado),
      'TipoCuenta': EnumToString.convertToString(cartera.cuenta),
    });
  }

  Future<void> updateCarteraMecanico(String idMecanico, double valor) async {
    var doc = await mecanicosCollection.doc(idMecanico).snapshots().first;
    var valorActual = doc.data()['cartera'] ?? 0;
    return await mecanicosCollection
        .doc(idMecanico)
        .update({'cartera': (valorActual + valor)});
  }

  Future<void> notificarTaller(
      String idTaller, String titulo, String contenido) async {
    var doc = await talleresCollection.doc(idTaller).snapshots().first;
    var token = doc.data()['fcmToken'] ?? '';
    var isLogin = doc.data()['isLogin'] ?? false;
    if (token != null && token != "" && isLogin) {
      Singleton().notificador.sendAndRetrieveMessage(token, titulo, contenido);
    }
    return null;
  }

  Future<void> notificarMecanico(
      String idMecanico, String titulo, String contenido) async {
    var doc = await mecanicosCollection.doc(idMecanico).snapshots().first;
    var token = doc.data()['fcmToken'] ?? '';
    var isLogin = doc.data()['isLogin'] ?? false;
    if (token != null && token != "" && isLogin) {
      Singleton().notificador.sendAndRetrieveMessage(token, titulo, contenido);
    }
    return null;
  }

  Future<UserMecanico> obtenerMecanico(String idMecanico) {
    return mecanicosCollection
        .doc(idMecanico)
        .snapshots()
        .map(_userMecanicoFromSnapshot)
        .first;
  }

  Future<UserTaller> obtenerTaller(String idTaller) {
    return mecanicosCollection
        .doc(idTaller)
        .snapshots()
        .map(_tallerFromSnapshot)
        .first;
  }

  UserTaller _tallerFromSnapshot(DocumentSnapshot snapshot) {
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
      latitud: snapshot.data()['latitud'],
      longitud: snapshot.data()['longitud'],
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
}
