<template>
  <div>
    <div class="intro-y flex items-center mt-8">
      <h2 class="text-lg font-medium mr-auto">Configuracion</h2>
    </div>
    <div class="grid grid-cols-12 gap-6">
      <div
        class="col-span-12 lg:col-span-4 2xl:col-span-3 flex lg:block flex-col-reverse"
      >
        <div class="intro-y box mt-5">
          <div class="relative flex items-center p-5">
            <div class="ml-4 mr-auto">
              <div class="font-medium text-base">
                Tu mecánico en línea
              </div>
              <div class="text-gray-600">
                Configuración de la aplicación móvil
              </div>
            </div>
          </div>
          <div class="p-5 border-t border-gray-200 dark:border-dark-5">
            <a
              class="flex items-center cursor-pointer"
              :class="{ 'text-theme-17 font-medium': opcionMenu == 1 }"
              @click="opcionMenu = 1"
            >
              <ActivityIcon class="w-4 h-4 mr-2" /> Configuración general
            </a>
            <a
              class="flex items-center mt-5 cursor-pointer"
              :class="{ 'text-theme-17 font-medium': opcionMenu == 2 }"
              @click="opcionMenu = 2"
            >
              <BoxIcon class="w-4 h-4 mr-2" /> Parametros de la aplicación
            </a>
            <a
              class="flex items-center mt-5 cursor-pointer"
              :class="{ 'text-theme-17 font-medium': opcionMenu == 3 }"
              @click="opcionMenu = 3"
            >
              <LockIcon class="w-4 h-4 mr-2" /> Llaves de la pasarela de pagos
            </a>
            <a
              class="flex items-center mt-5 cursor-pointer"
              :class="{ 'text-theme-17 font-medium': opcionMenu == 4 }"
              @click="opcionMenu = 4"
            >
              <CustomIcon class="w-4 h-4 mr-2" /> Parametros de WhatsApp
            </a>
          </div>
        </div>
      </div>
      <div class="col-span-12 lg:col-span-8 2xl:col-span-9">
        <div class="intro-y box lg:mt-5" v-show="opcionMenu == 1">
          <div
            class="flex items-center p-5 border-b border-gray-200 dark:border-dark-5"
          >
            <h2 class="font-medium text-base mr-auto">Configuración general</h2>
          </div>
          <div class="p-5">
            <div class="flex flex-col-reverse xl:flex-row flex-col">
              <div class="flex-1 mt-6 xl:mt-0">
                <div class="grid grid-cols-12 gap-x-5">
                  <div class="col-span-12 2xl:col-span-6">
                    <div>
                      <label for="emailcontacto" class="form-label"
                        >Correo electrónico</label
                      >
                      <input
                        id="emailcontacto"
                        type="text"
                        class="form-control"
                        placeholder="Correo electronico"
                        v-model="parametros.emailContacto"
                      />
                    </div>
                    <div class="mt-3">
                      <label for="ciudades" class="form-label">Ciudades</label>
                      <TomSelect
                        id="ciudades"
                        v-model="ciudadSeleccionada"
                        class="w-full"
                      >
                        <option
                          :value="item"
                          v-for="item in tempCiudades"
                          :key="item"
                          >{{ item }}</option
                        >
                      </TomSelect>
                      <button
                        class="btn btn-primary mr-2 mb-2 float-right m-2"
                        @click="showModalCiudades"
                      >
                        <PlusIcon class="w-4 h-4 mr-2" /> Agregar ciudad
                      </button>
                    </div>
                    <div class="mt-5">
                      <div class="form-group">
                        <label for="horariotalleres" class="form-label"
                          >Horario de los talleres</label
                        >
                        <textarea
                          id="horariotalleres"
                          class="form-control"
                          rows="3"
                          placeholder="Horario de los talleres"
                          v-model="parametros.horarioTalleres"
                        ></textarea>
                      </div>
                    </div>
                  </div>
                </div>
                <button
                  type="button"
                  class="btn btn-primary w-20 mt-3 float-right"
                  @click="actualizarConfiguracion()"
                >
                  Guardar
                </button>
              </div>
            </div>
          </div>
        </div>
        <div class="intro-y box mt-5" v-show="opcionMenu == 2">
          <div
            class="flex items-center p-5 border-b border-gray-200 dark:border-dark-5"
          >
            <h2 class="font-medium text-base mr-auto">
              Parametros de la aplicación
            </h2>
          </div>
          <div class="p-5">
            <div class="flex flex-col-reverse xl:flex-row flex-col">
              <div class="flex-1 mt-6 xl:mt-0">
                <div class="grid grid-cols-12 gap-x-5">
                  <div class="col-span-12 xl:col-span-6">
                    <div>
                      <label for="consecutivo" class="form-label"
                        >Consecutivo Talleres</label
                      >
                      <input
                        id="consecutivo"
                        type="number"
                        class="form-control"
                        placeholder="Consecutivo"
                        v-model="parametros.consecutivo"
                      />
                    </div>
                    <div class="mt-3">
                      <label for="distancia" class="form-label"
                        >Distancia de busqueda</label
                      >
                      <input
                        id="distancia"
                        type="number"
                        step="any"
                        class="form-control"
                        placeholder="Distancia"
                        v-model="parametros.distanciaBusqueda"
                      />
                    </div>
                  </div>
                  <div class="col-span-12 xl:col-span-6">
                    <div class="mt-3 xl:mt-0">
                      <label for="referencia" class="form-label"
                        >Referencia de pago</label
                      >
                      <input
                        id="referencia"
                        type="number"
                        class="form-control"
                        placeholder="Input text"
                        v-model="parametros.consecutivoPagos"
                      />
                    </div>
                    <div class="mt-3">
                      <label for="valor" class="form-label"
                        >Valor de los domicilios
                      </label>
                      <input
                        id="valor"
                        type="text"
                        class="form-control"
                        placeholder="Precio domicilios"
                        v-model="parametros.valorDomicilioMecanicos"
                      />
                    </div>
                  </div>
                </div>
                <button
                  type="button"
                  class="btn btn-primary w-20 mt-3 float-right"
                  @click="actualizarConfiguracion()"
                >
                  Guardar
                </button>
              </div>
            </div>
          </div>
        </div>
        <div class="intro-y box mt-5" v-show="opcionMenu == 3">
          <div
            class="flex items-center p-5 border-b border-gray-200 dark:border-dark-5"
          >
            <h2 class="font-medium text-base mr-auto">Personal Information</h2>
          </div>
          <div class="p-5">
            <div class="flex flex-col-reverse xl:flex-row flex-col">
              <div class="flex-1 mt-6 xl:mt-0">
                <div class="grid grid-cols-12 gap-x-5">
                  <div class="col-span-12 xl:col-span-12">
                    <div>
                      <label for="privada" class="form-label"
                        >Llave Privada de Wompi</label
                      >
                      <input
                        id="privada"
                        type="text"
                        class="form-control"
                        placeholder="Llave privada wompi"
                        v-model="parametros.llavePrvWompi"
                      />
                    </div>
                    <div class="mt-3">
                      <label for="publica" class="form-label"
                        >Llave pública de Wompi</label
                      >
                      <input
                        id="publica"
                        type="text"
                        class="form-control"
                        placeholder="Llave pública wompi"
                        v-model="parametros.llavePubWompi"
                      />
                    </div>
                    <div class="mt-3">
                      <label for="urlpagos" class="form-label"
                        >Url consulta de pagos</label
                      >
                      <input
                        id="urlpagos"
                        type="text"
                        class="form-control"
                        placeholder="Url consulta de pagos"
                        v-model="parametros.urlPagos"
                      />
                    </div>
                  </div>
                </div>
                <button
                  type="button"
                  class="btn btn-primary w-20 mr-auto float-right mt-3"
                  @click="actualizarConfiguracion()"
                >
                  Guardar
                </button>
              </div>
            </div>
          </div>
        </div>
        <div class="intro-y box mt-5" v-show="opcionMenu == 4">
          <div
            class="flex items-center p-5 border-b border-gray-200 dark:border-dark-5"
          >
            <h2 class="font-medium text-base mr-auto">
              Parametros de WhatsApp
            </h2>
          </div>
          <div class="p-5">
            <div class="flex flex-col-reverse xl:flex-row flex-col">
              <div class="flex-1 mt-6 xl:mt-0">
                <div class="grid grid-cols-12 gap-x-5">
                  <div class="col-span-12 xl:col-span-6">
                    <div>
                      <label for="telefonowa" class="form-label"
                        >Teléfono WhatsApp ayuda</label
                      >
                      <input
                        id="telefonowa"
                        type="text"
                        class="form-control"
                        placeholder="Teléfono WhatsApp ayuda"
                        v-model="parametros.telefonoWhatsAppAyuda"
                      />
                    </div>
                    <div class="mt-3">
                      <label for="referenciapago" class="form-label"
                        >Mensaje WhatsApp ayuda</label
                      >
                      <textarea
                        type="text"
                        class="form-control"
                        rows="3"
                        placeholder="Mensaje WhatsApp ayuda"
                        v-model="parametros.mensajeWhatsappAyuda"
                      ></textarea>
                    </div>
                  </div>
                  <div class="col-span-12 xl:col-span-6 xs:mt-3">
                    <div>
                      <label for="telefonosa" class="form-label"
                        >Teléfono WhatsApp soporte</label
                      >
                      <input
                        id="telefonos"
                        type="text"
                        class="form-control"
                        placeholder="Teléfono WhatsApp soporte"
                        v-model="parametros.telefonoWhatsAppSoporte"
                      />
                    </div>
                    <div class="mt-3">
                      <label for="mws" class="form-label"
                        >Mensaje WhatsApp soporte</label
                      >
                      <textarea
                        id="mws"
                        class="form-control "
                        rows="3"
                        placeholder="Mensaje WhatsApp soporte"
                        v-model="parametros.mensajeWhatsappSoporte"
                      ></textarea>
                    </div>
                  </div>
                </div>
                <button
                  type="button"
                  class="btn btn-primary w-20 mr-auto float-right mt-3"
                  @click="actualizarConfiguracion()"
                >
                  Guardar
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div
      id="modal-ciudades"
      aria-hidden="true"
      data-backdrop="static"
      class="modal"
      tabindex="-1"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <!-- BEGIN: Modal Body -->
          <div class="modal-body grid grid-cols-12 gap-4 gap-y-3">
            <div class="col-span-12">
              <label for="ciu" class="form-label">Nombre de la ciudad</label>
              <div class="input-group">
                <input
                  v-model="ciudad"
                  id="ciu"
                  type="text"
                  class="form-control"
                  placeholder="Ciudad"
                />
                <div class="input-group-append">
                  <button
                    class="btn btn-primary m-2 float-right"
                    @click="agregarCiudades()"
                  >
                    <PlusIcon class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
            <div class="col-span-12">
              <div
                class="overflow-x-auto scrollbar-hidden"
                style="height:300px"
              >
                <table class="table table-report -mt-2">
                  <thead>
                    <tr>
                      <th class="whitespace-nowrap">CIUDAD</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr
                      v-for="item in tempCiudades"
                      :key="item"
                      class="intro-x"
                    >
                      <td>
                        <a href="" class="font-medium whitespace-nowrap">{{
                          item
                        }}</a>
                      </td>
                      <td class="table-report__action w-56">
                        <div class="flex justify-center items-center">
                          <a
                            class="flex items-center text-theme-24"
                            href="javascript:;"
                            data-toggle="modal"
                            data-target="#delete-confirmation-modal"
                            @click="removerCiudad(item)"
                          >
                            <Trash2Icon class="w-4 h-4 mr-1" /> Borrar
                          </a>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
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
              @click="actualizarConfiguracion()"
            >
              Guardar
            </button>
          </div>
          <!-- END: Modal Footer -->
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import { mapActions, mapGetters } from 'vuex'
import CustomIcon from '../components/CustomIcon'

export default defineComponent({
  components: {
    CustomIcon
  },
  data() {
    return {
      loading: false,
      parametros: {},
      opcionMenu: 1,
      ciudadSeleccionada: '',
      valor: 1235,
      tableCiudades: null,
      tempCiudades: [],
      ciudad: ''
    }
  },
  methods: {
    ...mapActions(['getConfiguracionStore', 'updateConfiguracion']),
    showModalCiudades() {
      this.ciudadSeleccionada = ''
      cash('#modal-ciudades').modal('show')
    },
    agregarCiudades() {
      if (this.ciudad) {
        this.tempCiudades.push(this.ciudad)
        this.ciudad = ''
        this.tempCiudades = this.tempCiudades.reverse()
      }
    },
    removerCiudad(item) {
      var i = this.tempCiudades.indexOf(item)
      if (i !== -1) {
        this.tempCiudades.splice(i, 1)
      }
    },
    actualizarConfiguracion() {
      this.updateConfiguracion({
        ...this.parametros,
        ciudades: this.tempCiudades
      })
      cash('#modal-ciudades').modal('hide')
    }
  },
  computed: {
    ...mapGetters(['gettersConfiguracionStore'])
  },
  async mounted() {
    await this.getConfiguracionStore()
    this.parametros = this.gettersConfiguracionStore
    this.tempCiudades = this.parametros.ciudades
  }
})
</script>
