<template>
  <div>
    <div class="intro-y flex flex-col sm:flex-row items-center mt-8">
      <h2 class="text-lg font-medium mr-auto">Talleres</h2>
      <div class="w-full sm:w-auto flex mt-4 sm:mt-0">
        <button class="btn btn-primary shadow-md mr-2" @click="showModal()">
          Nuevo taller
        </button>
      </div>
    </div>
    <!-- BEGIN: HTML Table Data -->
    <div class="intro-y box p-5 mt-5">
      <div class="flex flex-col sm:flex-row sm:items-end xl:items-start">
        <form id="tabulator-html-filter-form" class="xl:flex sm:mr-auto">
          <div class="sm:flex items-center sm:mr-4 mt-2 xl:mt-0">
            <input
              @keydown.enter.prevent
              type="text"
              class="form-control sm:w-40 2xl:w-full mt-2 sm:mt-0"
              placeholder="Buscar nombre..."
              v-model="buscar"
            />
          </div>
        </form>
      </div>
      <div class="overflow-x-auto scrollbar-hidden">
        <div
          id="tabulator"
          ref="tableRef"
          class="mt-5 table-report table-report--tabulator"
        ></div>
      </div>
    </div>
    <!-- END: HTML Table Data -->
    <div
      id="modal-talleres"
      class="modal"
      tabindex="-1"
      aria-hidden="true"
      data-backdrop="static"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <!-- BEGIN: Modal Header -->
          <div class="modal-header">
            <h2 class="font-medium text-base mr-auto">
              {{ editarFlag ? 'Editar' : 'Nuevo' }} taller
            </h2>
          </div>
          <!-- END: Modal Header -->
          <!-- BEGIN: Modal Body -->
          <div class="modal-body grid grid-cols-12 gap-4 gap-y-3">
            <div class="col-span-12 sm:col-span-6">
              <div class="input-form"></div>
              <label
                for="nombres"
                class="form-label w-full flex flex-col sm:flex-row"
                :class="{ 'text-theme-5': nombres.error }"
                >Nombres *</label
              >
              <input
                id="nombres"
                type="text"
                class="form-control"
                :class="{ 'border-theme-5': nombres.error }"
                placeholder="nombres"
                v-model.trim="nombres.valor"
              />
              <template v-if="nombres.error">
                <div class="text-theme-5 mt-2">
                  Este campo es requerido
                </div>
              </template>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="modal-form-2" class="form-label">Email</label>
              <input
                id="modal-form-2"
                type="email"
                class="form-control"
                placeholder="email@mail.com"
                v-model="email"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="cel" class="form-label">Celular</label>
              <input
                id="cel"
                type="number"
                class="form-control"
                placeholder="Celular"
                v-model="celular"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="tel1" class="form-label">Telefono 1</label>
              <input
                id="tel1"
                type="tel"
                class="form-control"
                placeholder="Telefono"
                v-model="telefono1"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="tel2" class="form-label">Telefono 2</label>
              <input
                id="tel2"
                type="tel"
                class="form-control"
                placeholder="Telefono"
                v-model="telefono2"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="dir" class="form-label">Dirección</label>
              <input
                id="dir"
                type="text"
                class="form-control"
                placeholder="Direccion"
                v-model="direccion"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="ciudad" class="form-label">Ciudad</label>
              <TomSelect id="ciudades" v-model="ciudad" class="w-full">
                <option
                  :value="item"
                  v-for="item in parametros.ciudades"
                  :key="item"
                  >{{ item }}</option
                >
              </TomSelect>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="nit" class="form-label">Nit o Cédula</label>
              <input
                id="nit"
                type="text"
                class="form-control"
                placeholder="Nit"
                v-model="nit"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="propietario" class="form-label">Propietario</label>
              <input
                id="propietario"
                type="text"
                class="form-control"
                placeholder="Propietario"
                v-model="propietario"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="marcas" class="form-label">Marcas</label>
              <input
                id="marcas"
                type="text"
                class="form-control"
                placeholder="marcas"
                v-model="marcas"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="servicio" class="form-label">Servicios</label>
              <input
                id="servicio"
                type="text"
                class="form-control"
                placeholder="servicios"
                v-model="servicios"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="banco" class="form-label">Banco</label>
              <input
                id="banco"
                type="text"
                class="form-control"
                placeholder="Banco"
                v-model="banco"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="cuentabancario" class="form-label"
                >Cuenta bancaria</label
              >
              <input
                id="cuentabancario"
                type="text"
                class="form-control"
                placeholder="Cuenta bancaria"
                v-model="cuentabancaria"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <div class="mt-3">
                <label for="herramienta">Tiene herramientas</label>
                <div class="mt-2">
                  <input
                    id="herramienta"
                    type="checkbox"
                    v-model="herramientas"
                    class="form-check-switch"
                  />
                </div>
              </div>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <div class="mt-3">
                <label for="latitud">latitud</label>
                <div class="mt-2">
                  <input
                    id="latitud"
                    type="text"
                    v-model="latitud"
                    placeholder="4.7109957140873515"
                    class="form-control"
                  />
                </div>
              </div>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <div class="mt-3">
                <label for="herramienta">Longitud</label>
                <div class="mt-2">
                  <input
                    id="Longitud"
                    type="text"
                    v-model="longitud"
                    placeholder="-74.07205838301302"
                    class="form-control"
                  />
                </div>
              </div>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="pass" class="form-label">Contraseña</label>
              <input
                id="pass"
                type="password"
                class="form-control"
                placeholder="Contraseña"
                v-model="password"
              />
            </div>
          </div>
          <!-- END: Modal Body -->
          <!-- BEGIN: Modal Footer -->
          <div class="modal-footer text-right">
            <button
              type="button"
              data-dismiss="modal"
              class="btn btn-outline-secondary w-20 mr-1"
            >
              Cancelar
            </button>
            <button
              type="button"
              class="btn btn-primary w-20"
              @click="editarFlag ? editarTaller() : crearTaller()"
            >
              {{ editarFlag ? 'Editar' : 'Crear' }}
            </button>
          </div>
          <!-- END: Modal Footer -->
        </div>
      </div>
    </div>
    <div id="delete-modal" class="modal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-body p-0">
            <div class="p-5 text-center">
              <XCircleIcon class="w-16 h-16 text-theme-24 mx-auto mt-3" />
              <div class="text-3xl mt-5">Está seguro?</div>
              <div class="text-gray-600 mt-2">
                Eliminar este registro? <br />Esto será permanente
              </div>
            </div>
            <div class="px-5 pb-8 text-center">
              <button
                type="button"
                data-dismiss="modal"
                class="btn btn-outline-secondary w-24 dark:border-dark-5 dark:text-gray-300 mr-1"
              >
                Cancelar
              </button>
              <button
                type="button"
                class="btn btn-danger w-24"
                @click="borrar()"
              >
                Borrar
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import { mapActions, mapGetters } from 'vuex'
import feather from 'feather-icons'
import Tabulator from 'tabulator-tables'
export default defineComponent({
  data() {
    return {
      talleres: [],
      oldTalleres: [],
      editarFlag: false,
      nombres: {
        valor: '',
        error: false
      },
      email: '',
      celular: '',
      telefono1: '',
      telefono2: '',
      direccion: '',
      ciudad: '',
      nit: '',
      propietario: '',
      marcas: '',
      servicios: '',
      banco: '',
      cuentabancaria: '',
      herramientas: false,
      password: '',
      latitud: '',
      longitud: '',
      tallerSelected: {},
      parametros: {},
      buscar: ''
    }
  },
  methods: {
    ...mapActions([
      'getTalleresStore',
      'deleteTalleres',
      'createTaller',
      'updateTaller',
      'getConfiguracionStore'
    ]), // Esto llama al metodo en el store que trae los usuarios
    async initTabulator() {
      const self = this
      this.tabulator = new Tabulator(this.$refs.tableRef, {
        responsiveLayout: 'collapse',
        responsiveLayoutCollapseStartOpen: false,
        layout: 'fitColumns',
        pagination: 'local',
        printAsHtml: true,
        printStyled: true,
        paginationSize: 10,
        paginationSizeSelector: [10, 20, 30, 40],
        placeholder: 'No se encontraron registros',
        renderComplete() {
          feather.replace({
            'stroke-width': 1.5
          })
        },
        data: this.talleres,
        columns: [
          {
            formatter: 'responsiveCollapse',
            width: 40,
            minWidth: 30,
            hozAlign: 'center',
            resizable: false,
            headerSort: false
          },
          // For HTML table
          {
            title: 'Nombres',
            minWidth: 200,
            responsive: 0,
            field: 'nombre',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'IMAGEN',
            minWidth: 200,
            field: 'urlImagen',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return (
                cell.getData().urlImagen &&
                `<div class="w-12 h-12 image-fit">
                  <img
                    alt="Logo"
                    class="rounded-full"
                    src="${cell.getData().urlImagen}"
                  />
                </div>`
              )
            }
          },
          {
            title: 'EMAIL',
            minWidth: 200,
            field: 'email',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'CELULAR',
            minWidth: 200,
            field: 'celular',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'TELEFONO 1',
            minWidth: 200,
            field: 'telefono1',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'TELEFONO 2',
            minWidth: 200,
            field: 'telefono2',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'DIRECCION',
            minWidth: 200,
            field: 'direccion',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'CIUDAD',
            minWidth: 200,
            field: 'ciudad',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'CARTERA',
            minWidth: 200,
            field: 'cartera',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return new Intl.NumberFormat('es-CO', {
                style: 'currency',
                currency: 'COP'
              }).format(cell.getValue())
            }
          },
          {
            title: 'NIT',
            minWidth: 200,
            field: 'nit',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'PROPIETARIO',
            minWidth: 200,
            field: 'propietario',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'MARCAS',
            minWidth: 200,
            field: 'marcas',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'SERVICIOS',
            minWidth: 200,
            field: 'servicios',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'BANCO',
            minWidth: 200,
            field: 'banco',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'CUENTA BANCARIA',
            minWidth: 200,
            field: 'cuentaBancaria',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'HERRAMIENTAS',
            minWidth: 200,
            field: 'tieneHerramientas',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return `<div class="flex items-center lg:justify-center ${
                cell.getData().tieneHerramientas
                  ? 'text-theme-10'
                  : 'text-theme-24'
              }">
                ${cell.getData().tieneHerramientas ? 'SI' : 'NO'}
              </div>`
            }
          },
          {
            title: 'SESION',
            minWidth: 200,
            field: 'isLogin',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return `<div class="flex items-center lg:justify-center ${
                cell.getData().isLogin ? 'text-theme-10' : 'text-theme-24'
              }">
              ${cell.getData().isLogin ? 'Activo' : 'Inactivo'}
              </div>`
            }
          },
          {
            title: 'LATITUD/LONGITUD',
            minWidth: 200,
            field: 'latitud',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return `${cell.getData().latitud} / ${cell.getData().longitud}`
            }
          },
          {
            title: '',
            minWidth: 100,
            field: 'actions',
            responsive: 0,
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter() {
              return `<div class="flex lg:justify-center items-center">
                <a class="flex items-center mr-3" href="javascript:;" id="edit">
                  <i data-feather="check-square" class="w-4 h-4 mr-1"></i> Editar
                </a>
              </div>`
            },
            cellClick: function(e, cell) {
              self.showEditModal(cell._cell.row.data)
            }
          },
          {
            title: '',
            minWidth: 100,
            field: 'actions',
            responsive: 0,
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter() {
              return `<div class="flex lg:justify-center items-center">
                <a class="flex items-center text-theme-24" href="javascript:;">
                  <i data-feather="trash-2" class="w-4 h-4 mr-1"></i> Eliminar
                </a>
              </div>`
            },
            cellClick: function(e, cell) {
              self.tallerSelected = cell._cell.row.data
              self.showAlertDelete()
            }
          }
        ]
      })
    },
    showModal() {
      this.editarFlag = false
      this.nombres = {
        valor: '',
        error: false
      }
      this.email = ''
      this.celular = ''
      this.telefono1 = ''
      this.telefono2 = ''
      this.direccion = ''
      this.ciudad = ''
      this.nit = ''
      this.propietario = ''
      this.marcas = ''
      this.servicios = ''
      this.banco = ''
      this.cuentabancaria = ''
      this.herramientas = ''
      this.password = ''
      cash('#modal-talleres').modal('show')
    },
    showEditModal(data) {
      this.tallerSelected = data
      this.editarFlag = true
      this.nombres = data.nombre
      this.email = data.email
      this.celular = data.celular
      this.telefono1 = data.telefono1
      this.telefono2 = data.telefono2
      this.direccion = data.direccion
      this.ciudad = data.ciudad
      this.nit = data.nit
      this.propietario = data.propietario
      this.marcas = data.marcas
      this.servicios = data.servicios
      this.banco = data.banco
      this.cuentabancaria = data.cuentaBancaria
      this.herramientas = data.tieneHerramientas
      this.password = data.password
      this.latitud = data.latitud
      this.longitud = data.longitud
      cash('#modal-talleres').modal('show')
    },
    cancelModal() {
      cash('#modal-talleres').modal('hide')
    },
    async crearTaller() {
      this.nombres.error = this.campoRequerido(this.nombres.valor)
      if (!this.nombres.error) {
        const data = {
          nit: this.nit,
          email: this.email,
          password: this.password,
          nombre: this.nombres,
          propietario: this.propietario,
          celular: this.celular,
          direccion: this.direccion,
          ciudad: this.ciudad,
          telefono1: this.telefono1,
          telefono2: this.telefono2,
          servicios: this.servicios,
          marcas: this.marcas,
          tieneHerramientas: this.herramientas,
          cuentaBancaria: this.cuentabancaria,
          banco: this.banco,
          latitud: this.latitud,
          longitud: this.longitud
        }
        this.createTaller(data)
        this.cancelModal()
        await this.getTalleresStore()
        this.initTabulator()
      }
    },
    async editarTaller() {
      const data = {
        uid: this.tallerSelected.uid,
        nit: this.nit,
        email: this.email,
        password: this.password,
        nombre: this.nombres,
        propietario: this.propietario,
        celular: this.celular,
        direccion: this.direccion,
        ciudad: this.ciudad,
        telefono1: this.telefono1,
        telefono2: this.telefono2,
        servicios: this.servicios,
        marcas: this.marcas,
        tieneHerramientas: this.herramientas,
        cuentaBancaria: this.cuentabancaria,
        banco: this.banco,
        cartera: this.tallerSelected.cartera,
        fcmToken: this.tallerSelected.fcmToken,
        isLogin: this.tallerSelected.isLogin,
        urlImagen: this.tallerSelected.urlImagen,
        latitud: this.latitud,
        longitud: this.longitud
      }
      this.updateTaller(data)
      this.cancelModal()
      await this.getTalleresStore()
      this.initTabulator()
    },
    showAlertDelete() {
      cash('#delete-modal').modal('show')
    },
    async borrar() {
      cash('#delete-modal').modal('hide')
      this.deleteTalleres(this.tallerSelected)
      this.tallerSelected = {}
      await this.getTalleresStore()
      this.initTabulator()
    },
    campoRequerido(campo) {
      if (!campo) {
        return true
      }
      return false
    }
  },
  computed: {
    ...mapGetters(['gettersTalleresStore', 'gettersConfiguracionStore'])
  },
  watch: {
    buscar(newValue, oldValue) {
      let talleresTemp = []
      if (newValue) {
        talleresTemp = this.talleres.filter(taller =>
          taller.nombre.toLowerCase().includes(this.buscar.toLowerCase())
        )
      } else if (newValue == '') {
        talleresTemp = this.oldTalleres
      }
      this.tabulator.replaceData(talleresTemp)
    }
  },
  async mounted() {
    await this.getTalleresStore()
    await this.getConfiguracionStore()
    this.talleres = await this.gettersTalleresStore
    this.oldTalleres = this.talleres
    this.initTabulator()
    this.parametros = this.gettersConfiguracionStore
  }
})
</script>
