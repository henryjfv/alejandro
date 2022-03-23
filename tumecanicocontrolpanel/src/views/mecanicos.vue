<template>
  <div>
    <div class="intro-y flex flex-col sm:flex-row items-center mt-8">
      <h2 class="text-lg font-medium mr-auto">Mecánicos</h2>
      <div class="w-full sm:w-auto flex mt-4 sm:mt-0">
        <button class="btn btn-primary shadow-md mr-2" @click="showModal()">
          Nuevo Mecánico
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
      id="modal-mecanicos"
      class="modal"
      tabindex="-1"
      ca
      aria-hidden="true"
      data-backdrop="static"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <!-- BEGIN: Modal Header -->
          <div class="modal-header">
            <h2 class="font-medium text-base mr-auto">
              {{ editarFlag ? 'Editar' : 'Nuevo' }} mecánico
            </h2>
          </div>
          <!-- END: Modal Header -->
          <!-- BEGIN: Modal Body -->
          <div class="modal-body grid grid-cols-12 gap-4 gap-y-3">
            <div class="col-span-12 sm:col-span-6">
              <label for="modal-form-1" class="form-label">Nombres</label>
              <input
                id="modal-form-1"
                type="text"
                class="form-control"
                placeholder="nombres"
                v-model="nombres"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="modal-form-2" class="form-label">Email</label>
              <input
                id="modal-form-2"
                type="email"
                class="form-control"
                placeholder="email@mail.com"
                v-model="email"
                :disabled="editarFlag"
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
              <label for="modal-cedula" class="form-label">Cédula</label>
              <input
                id="modal-cedula"
                type="text"
                class="form-control"
                placeholder="Cedula"
                v-model="cedula"
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
              <label for="cuenta" class="form-label">Cuenta bancaria</label>
              <input
                id="cuenta"
                type="text"
                class="form-control"
                placeholder="Cuenta bancaria"
                v-model="cuentabancaria"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <div class="mt-3">
                <label>Técnico</label>
                <div class="mt-2">
                  <input
                    type="checkbox"
                    v-model="tecnico"
                    class="form-check-switch"
                  />
                </div>
              </div>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <div class="mt-3">
                <label>Transporte</label>
                <div class="mt-2">
                  <input
                    type="checkbox"
                    v-model="transporte"
                    class="form-check-switch"
                  />
                </div>
              </div>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <div class="mt-3">
                <label>Herramientas</label>
                <div class="mt-2">
                  <input
                    type="checkbox"
                    v-model="herramientas"
                    class="form-check-switch"
                  />
                </div>
              </div>
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="modal-form-4" class="form-label">Contraseña</label>
              <input
                id="modal-form-4"
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
              @click="editarFlag ? editarMecanico() : crearMecanico()"
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
                @click="borrarMecanico()"
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
      mecanicos: [],
      oldMecanicos: [],
      editarFlag: false,
      nombres: '',
      email: '',
      celular: '',
      cedula: '',
      direccion: '',
      ciudad: '',
      marcas: '',
      banco: '',
      cuentabancaria: '',
      tecnico: '',
      transporte: '',
      herramientas: '',
      password: '',
      mecanicoSelected: {},
      parametros: {},
      buscar: ''
    }
  },
  methods: {
    ...mapActions([
      'getMecanicosStore',
      'createMecanico',
      'updateMecanico',
      'deleteMecanico',
      'getConfiguracionStore'
    ]), // Esto llama al metodo en el store que trae los usuarios
    initTabulator() {
      const self = this
      this.tabulator = new Tabulator(this.$refs.tableRef, {
        layout: 'fitColumns',
        responsiveLayout: 'collapse',
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
        data: this.mecanicos,
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
            title: 'CÉDULA',
            minWidth: 200,
            field: 'cedula',
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
            title: 'MARCAS',
            minWidth: 200,
            field: 'marcas',
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
            title: 'TÉCNICO',
            minWidth: 200,
            field: 'esMecanicoTecnico',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return `<div class="flex items-center lg:justify-center ${
                cell.getData().esMecanicoTecnico
                  ? 'text-theme-10'
                  : 'text-theme-24'
              }">
                ${cell.getData().esMecanicoTecnico ? 'SI' : 'NO'}
              </div>`
            }
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
            title: 'TRANSPORTE',
            minWidth: 200,
            field: 'tieneTransporte',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return `<div class="flex items-center lg:justify-center ${
                cell.getData().tieneTransporte
                  ? 'text-theme-10'
                  : 'text-theme-24'
              }">
                ${cell.getData().tieneTransporte ? 'SI' : 'NO'}
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
            title: '',
            minWidth: 200,
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
            minWidth: 200,
            field: 'actions',
            responsive: 0,
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter() {
              return `<div class="flex lg:justify-center items-center">
                <a class="flex items-center mr-3" href="javascript:;" >
                  <i data-feather="trash" class="w-4 h-4 mr-1"></i> Eliminar
                </a>
              </div>`
            },
            cellClick: function(e, cell) {
              self.mecanicoSelected = cell._cell.row.data
              self.showAlertDeleteMecanic()
            }
          }
        ]
      })
    },
    showModal() {
      this.editarFlag = false
      cash('#modal-mecanicos').modal('show')
    },
    showEditModal(data) {
      this.editarFlag = true
      this.mecanicoSelected = data
      this.email = data.email
      this.password = data.password
      this.nombres = data.nombre
      this.cedula = data.cedula
      this.celular = data.celular
      this.direccion = data.direccion
      this.ciudad = data.ciudad
      this.tecnico = data.esMecanicoTecnico
      this.marcas = data.marcas
      this.transporte = data.tieneTransporte
      this.herramientas = data.tieneHerramientas
      this.cuentabancaria = data.cuentaBancaria
      this.banco = data.banco
      cash('#modal-mecanicos').modal('show')
    },
    async crearMecanico() {
      const data = {
        email: this.email,
        password: this.password,
        nombres: this.nombres,
        cedula: this.cedula,
        celular: this.celular,
        direccion: this.direccion,
        ciudad: this.ciudad,
        esMecanicoTecnico: this.tecnico,
        marcas: this.marcas,
        tieneTransporte: this.transporte,
        tieneHerramientas: this.herramientas,
        cuentaBancaria: this.cuentabancaria,
        banco: this.banco,
        cartera: 0,
        fcmToken: '',
        isLogin: false,
        urlImagen: ''
      }
      this.createMecanico(data)
      this.cancelModal()
      await this.getMecanicosStore()
      this.initTabulator()
    },
    async editarMecanico() {
      const data = {
        uid: this.mecanicoSelected.uid,
        email: this.email,
        password: this.password,
        nombres: this.nombres,
        cedula: this.cedula,
        celular: this.celular,
        direccion: this.direccion,
        ciudad: this.ciudad,
        esMecanicoTecnico: this.tecnico,
        marcas: this.marcas,
        tieneTransporte: this.transporte,
        tieneHerramientas: this.herramientas,
        cuentaBancaria: this.cuentabancaria,
        banco: this.banco,
        cartera: this.mecanicoSelected.cartera,
        fcmToken: this.mecanicoSelected.fcmToken,
        isLogin: this.mecanicoSelected.isLogin,
        urlImagen: this.mecanicoSelected.urlImagen
      }
      this.updateMecanico(data)
      this.cancelModal()
      await this.getMecanicosStore()
      this.initTabulator()
    },
    showAlertDeleteMecanic() {
      cash('#delete-modal').modal('show')
    },
    async borrarMecanico() {
      cash('#delete-modal').modal('hide')
      this.deleteMecanico(this.mecanicoSelected)
      this.mecanicoSelected = {}
      await this.getMecanicosStore()
      this.initTabulator()
    },
    cancelModal() {
      this.email = ''
      this.password = ''
      this.nombres = ''
      this.cedula = ''
      this.celular = ''
      this.direccion = ''
      this.ciudad = ''
      this.tenico = ''
      this.marcas = ''
      this.transporte = ''
      this.herramientas = ''
      this.cuentabancaria = ''
      this.banco = ''
      cash('#modal-mecanicos').modal('hide')
    }
  },
  computed: {
    ...mapGetters(['gettersMecanicosStore', 'gettersConfiguracionStore'])
  },
  watch: {
    buscar(newValue, oldValue) {
      let mecanicosTemp = []
      if (newValue) {
        mecanicosTemp = this.mecanicos.filter(mecanico =>
          mecanico.nombre.toLowerCase().includes(this.buscar.toLowerCase())
        )
      } else if (newValue == '') {
        mecanicosTemp = this.oldMecanicos
      }
      this.tabulator.replaceData(mecanicosTemp)
    }
  },
  async mounted() {
    await this.getMecanicosStore()
    await this.getConfiguracionStore()
    this.mecanicos = this.gettersMecanicosStore
    this.oldMecanicos = this.mecanicos
    this.initTabulator()
    this.parametros = this.gettersConfiguracionStore
  }
})
</script>
