import firebase from 'firebase/app'
import 'firebase/firestore'
import 'firebase/auth'

/* SANDBOX */
const firebaseConfig = {
  apiKey: 'AIzaSyCLFo1MUolteXXkL7pyMlDW0-9eZJPmfPw',
  authDomain: 'sandbox-tu-mecanico.firebaseapp.com',
  projectId: 'sandbox-tu-mecanico',
  storageBucket: 'sandbox-tu-mecanico.appspot.com',
  messagingSenderId: '892223962415',
  appId: '1:892223962415:web:10215a65616abcfda275da'
}
/* PRODUCCION */
/* const firebaseConfig = {
  apiKey: 'AIzaSyBiDa9NaTSE1K3d3oXAwgfYqDlyh5H-4kg',
  authDomain: 'tu-mecanico-en-linea-3301b.firebaseapp.com',
  databaseURL: 'https://tu-mecanico-en-linea-3301b.firebaseio.com',
  projectId: 'tu-mecanico-en-linea-3301b',
  storageBucket: 'tu-mecanico-en-linea-3301b.appspot.com',
  messagingSenderId: '564216932066',
  appId: '1:564216932066:web:0bf4fdcd8983873b5de0bb',
  measurementId: 'G-YL930V560S'
} */
// Initialize Firebase
firebase.initializeApp(firebaseConfig)
const db = firebase.firestore()
const auth = firebase.auth()

const state = () => {
  return {
    usuarios: [],
    talleres: [],
    mecanicos: [],
    carteras: [],
    domicilios: [],
    servicios: [],
    configuracion: {},
    dbFirebase: {}
  }
}
// mutations
const mutations = {
  setUsuarios(state, value) {
    state.usuarios = value
  },
  setTalleres(state, value) {
    state.talleres = value
  },
  setMecanicos(state, value) {
    state.mecanicos = value
  },
  setCarteras(state, value) {
    state.carteras = value
  },
  setDomicilios(state, value) {
    state.domicilios = value
  },
  setServicios(state, value) {
    state.servicios = value
  },
  setConfiguracion(state, value) {
    state.configuracion = value
  },
  setFirebase(state, value) {
    state.dbFirebase = value
  }
  /*   [types.SET_DARK_MODE](state, { darkMode }) {
      state.darkMode = darkMode
    } */
}
// actions
const actions = {
  async getUsuariosStore({ commit }) {
    const list = []
    const querySnapshot = await db.collection('usuarios_clientes').get()
    querySnapshot.forEach(doc => {
      list.push(doc.data())
    })
    commit('setUsuarios', list)
  },
  async setUsuariosStore({ commit }, data) {
    const result = await auth.createUserWithEmailAndPassword(
      data.email,
      data.password
    )
    const user = result.user
    await db
      .collection('usuarios_clientes')
      .doc(user.uid)
      .set({
        uid: user.uid,
        nombres: data.nombres,
        email: data.email,
        telefono: data.telefono,
        password: data.password
      })
  },
  deleteUsuario({ commit }, data) {
    db.collection('usuarios_clientes')
      .doc(data.uid)
      .delete()
      .then(() => {
        console.log('deleted!')
      })
      .catch(error => {
        console.error('Error removing document: ', error)
      })
  },
  async setDataUser({ commit }, data) {
    const resp = await db
      .collection('usuarios_clientes')
      .doc(data.uid)
      .set({
        uid: data.uid,
        nombres: data.nombres,
        email: data.email,
        telefono: data.telefono,
        password: data.password
      })
    return resp
  },
  async getTalleresStore({ commit }) {
    const list = []
    const querySnapshot = await db.collection('talleres').get()
    querySnapshot.forEach(doc => {
      list.push(doc.data())
    })
    commit('setTalleres', list)
  },
  async deleteTalleres({ commit }, data) {
    db.collection('talleres')
      .doc(data.uid)
      .delete()
      .then(() => {
        console.log('deleted!')
      })
      .catch(error => {
        console.error('Error removing document: ', error)
      })
  },
  async createTaller({ commit }, data) {
    console.log(data)
    const result = await auth.createUserWithEmailAndPassword(
      data.email,
      data.password
    )
    const user = result.user
    const resp = await db
      .collection('talleres')
      .doc(user.uid)
      .set({
        uid: user.uid,
        nit: data.nit,
        email: data.email,
        password: data.password,
        nombre: data.nombre,
        propietario: data.propietario,
        celular: data.celular,
        direccion: data.direccion,
        ciudad: data.ciudad,
        telefono1: data.telefono1 ? parseInt(data.telefono1) : 0,
        telefono2: data.telefono2 ? parseInt(data.telefono2) : 0,
        servicios: data.servicios,
        marcas: data.marcas,
        tieneHerramientas: data.tieneHerramientas,
        cuentaBancaria: data.cuentaBancaria,
        banco: data.banco,
        latitud: parseFloat(data.latitud),
        longitud: parseFloat(data.longitud),
        cartera: parseFloat(0.1)
      })
    return resp
  },
  async updateTaller({ commit }, data) {
    console.log(data)
    const resp = await db
      .collection('talleres')
      .doc(data.uid)
      .set({
        uid: data.uid,
        nit: data.nit,
        email: data.email,
        password: data.password,
        nombre: data.nombre,
        propietario: data.propietario,
        celular: data.celular,
        direccion: data.direccion,
        ciudad: data.ciudad,
        telefono1: data.telefono1 ? parseInt(data.telefono1) : 0,
        telefono2: data.telefono2 ? parseInt(data.telefono2) : 0,
        servicios: data.servicios,
        marcas: data.marcas,
        tieneHerramientas: data.tieneHerramientas,
        cuentaBancaria: data.cuentaBancaria,
        banco: data.banco,
        latitud: parseFloat(data.latitud),
        longitud: parseFloat(data.longitud),
        cartera: parseFloat(0.1)
      })
    return resp
  },
  async getMecanicosStore({ commit }) {
    const list = []
    const querySnapshot = await db.collection('mecanicos').get()
    querySnapshot.forEach(doc => {
      list.push(doc.data())
    })
    commit('setMecanicos', list)
  },
  async createMecanico({ commit }, data) {
    const result = await auth.createUserWithEmailAndPassword(
      data.email,
      data.password
    )
    const user = result.user
    const resp = await db
      .collection('mecanicos')
      .doc(user.uid)
      .set({
        uid: user.uid,
        email: data.email,
        password: data.password,
        nombre: data.nombres,
        cedula: data.cedula,
        celular: data.celular,
        direccion: data.direccion,
        ciudad: data.ciudad,
        esMecanicoTecnico: data.esMecanicoTecnico,
        marcas: data.marcas,
        tieneTransporte: data.tieneTransporte,
        tieneHerramientas: data.tieneHerramientas,
        cuentaBancaria: data.cuentaBancaria,
        banco: data.banco,
        cartera: parseFloat(0.1),
        fcmToken: '',
        isLogin: false,
        urlImagen: ''
      })
    return resp
  },
  async updateMecanico({ commit }, data) {
    const resp = await db
      .collection('mecanicos')
      .doc(data.uid)
      .set({
        uid: data.uid,
        email: data.email,
        password: data.password,
        nombre: data.nombres,
        cedula: data.cedula,
        celular: data.celular,
        direccion: data.direccion,
        ciudad: data.ciudad,
        esMecanicoTecnico: data.esMecanicoTecnico,
        marcas: data.marcas,
        tieneTransporte: data.tieneTransporte,
        tieneHerramientas: data.tieneHerramientas,
        cuentaBancaria: data.cuentaBancaria,
        banco: data.banco,
        cartera: data.cartera ? parseFloat(data.cartera) : parseFloat(0.1),
        fcmToken: data.fcmToken,
        isLogin: data.isLogin,
        urlImagen: data.urlImagen
      })
    return resp
  },
  async deleteMecanico({ commit }, data) {
    db.collection('mecanicos')
      .doc(data.uid)
      .delete()
      .then(() => {
        console.log('deleted!')
      })
      .catch(error => {
        console.error('Error removing document: ', error)
      })
  },
  async getCarterasStore({ commit }) {
    const list = []
    const querySnapshot = await db.collectionGroup('carteras').get()
    querySnapshot.forEach(doc => {
      list.push(doc.data())
    })
    commit('setCarteras', list)
  },
  async getDomiciliosStore({ commit }) {
    /* TODO probar esto para hacer actualizacion de datos en tiempo real
    const doc = db.collection('cities').doc('SF');
*/
    /*     const querySnapshot = await db.collectionGroup('domicilios').get()
    querySnapshot.forEach(doc => {
      list.push({
        id: doc.id,
        ...doc.data()
      })
    }) */
  },
  deleteDomicilio({ commit }, datos) {
    db.collection('domicilios')
      .doc(datos.idUsuario)
      .collection('domicilios')
      .doc(datos.id)
      .delete()
      .then(() => {
        console.log('deleted!')
      })
      .catch(error => {
        console.error('Error removing document: ', error)
      })
  },
  async getServiciosStore({ commit }) {
    /*     const list = []
    const querySnapshot = await db.collectionGroup('servicios').get()
    querySnapshot.forEach(doc => {
      list.push({
        id: doc.id,
        ...doc.data()
      })
    })
    commit('setServicios', list) */

    commit('setFirebase', await db)
  },
  deleteServicio({ commit }, datos) {
    db.collection('servicios')
      .doc(datos.idUsuario)
      .collection('servicios')
      .doc(datos.id)
      .delete()
      .then(() => {
        console.log('deleted!')
      })
      .catch(error => {
        console.error('Error removing document: ', error)
      })
  },
  async agregarObservacion({ commit }, data) {
    if (data.tipo == 'Domicilio') {
      await db
        .collection('domicilios')
        .doc(data.idUsuario)
        .collection('domicilios')
        .doc(data.id)
        .set({
          idUsuario: data.idUsuario,
          ciudadMunicipio: data.ciudadMunicipio,
          ubicacionActual: data.ubicacionActual,
          barrio: data.barrio,
          marcaCarro: data.marcaCarro,
          modelo: data.modelo,
          kilometraje: data.kilometraje,
          descripcion: data.descripcion,
          fecha: data.fecha,
          estado: data.estado,
          nombreUsuario: data.nombreUsuario,
          telefonoUsuario: data.telefonoUsuario,
          observaciones: data.observaciones
        })
    } else {
      await db
        .collection('servicios')
        .doc(data.idUsuario)
        .collection('servicios')
        .doc(data.idUsuario)
        .set({
          observaciones: data.observaciones
        })
    }
  },
  async getConfiguracionStore({ commit }) {
    var parametros = {}
    const querySnapshot = await db.collection('parametros').get()
    parametros = querySnapshot.docs[0].data()
    commit('setConfiguracion', parametros)
  },
  async updateConfiguracion({ commit }, data) {
    await db
      .collection('parametros')
      .doc('configuracion')
      .set(data)
  }
}
// getters
const getters = {
  gettersUsuariosStore(state) {
    return state.usuarios
  },
  gettersTalleresStore(state) {
    return state.talleres
  },
  gettersMecanicosStore(state) {
    return state.mecanicos
  },
  gettersCarterasStore(state) {
    return state.carteras
  },
  gettersDomiciliosStore(state) {
    return state.domicilios
  },
  gettersServiciosStore(state) {
    return state.dbFirebase
  },
  gettersConfiguracionStore(state) {
    return state.configuracion
  }
}
export default {
  state,
  getters,
  actions,
  mutations
}
