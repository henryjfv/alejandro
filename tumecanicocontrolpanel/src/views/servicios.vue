<template>
  <div>
    <h2 class="intro-y text-lg font-medium mt-10">Flujo del negocio</h2>
    <div class="grid grid-cols-12 gap-6 mt-5">
      <div
        class="intro-y col-span-12 flex flex-wrap sm:flex-nowrap items-center mt-2"
      >
        <!--    <button class="btn btn-primary shadow-md mr-2">Nuevo servicio</button> -->
        <div class="hidden md:block mx-auto text-gray-600">
          {{ flujodatos.length }} Registros
        </div>
        <!--         <div class="w-full sm:w-auto mt-3 sm:mt-0 sm:ml-auto md:ml-0">
          <div class="w-56 relative text-gray-700 dark:text-gray-300">
 <input
              type="text"
              class="form-control w-56 box pr-10 placeholder-theme-8"
              placeholder="Search..."
            />
            <SearchIcon
              class="w-4 h-4 absolute my-auto inset-y-0 mr-3 right-0"
            />
          </div>
        </div> -->
      </div>
      <!-- BEGIN: Users Layout -->
      <div
        v-for="(datos, i) in flujodatos"
        :key="i"
        class="intro-y col-span-12 md:col-span-6 lg:col-span-4"
      >
        <div
          class="box"
          :style="{
            'background-color': definirColor(datos.estado),
            'border-color': datos.fecha == null ? 'red' : '',
            'border-width': datos.fecha == null ? '1px' : '',
            'border-style': datos.fecha == null ? 'solid' : ''
          }"
        >
          <div class="text-center lg:text-left p-5">
            <button
              class="btn btn-danger py-1 px-2 float-right"
              @click="eliminar(datos)"
            >
              <Trash2Icon class="block mx-auto" />
            </button>
            <div>
              <label class="font-medium">Fecha:</label>
              {{
                new Date(datos.fecha).toLocaleDateString('es-ES', {
                  year: 'numeric',
                  month: 'short',
                  day: 'numeric'
                })
              }}
            </div>
            <div class="mt-2">
              <label class="font-medium">Servicio Prestado:</label>
              {{ datos.tipo ? datos.tipo : '' }}
            </div>
            <div class="text-center lg:text-left mt-3 lg:mt-0">
              <div>
                <label class="font-medium">Usuario: </label>
                {{ datos.nombreUsuario }}
              </div>
              <div>
                <label class="font-medium">Teléfono: </label>
                {{ datos.telefonoUsuario }}
              </div>
              <div>
                <label class="font-medium">Ciudad: </label>
                {{
                  datos.ciudadMunicipio ? datos.ciudadMunicipio : datos.ciudad
                }}
              </div>
              <div>
                <label class="font-medium">Barrio: </label>
                {{ datos.barrio }}
              </div>
              <div>
                <label class="font-medium">Ubicación: </label>
                {{ datos.ubicacionActual }}
              </div>
              <div>
                <label class="font-medium">Código de servicio: </label>
                {{ datos.referenciaPago }}
              </div>
              <div>
                <label class="font-medium">Estado del servicio: </label>
                {{ datos.estado }}
              </div>
              <hr class="mt-2" />
              <div class="mt-2">
                <label class="font-medium">Tipo de servicio: </label>
                {{ datos.tipoDeServicio }}
              </div>
              <div>
                <label class="font-medium">Hora del servicio: </label>
                {{ datos.hora }}
              </div>
              <div>
                <label class="font-medium">Taller: </label>
                {{ datos.taller }}
              </div>
              <div>
                <label class="font-medium">Valor servicio: </label>
                {{ datos.valor }}
              </div>
              <div>
                <label class="font-medium">Confirmado: </label>
                {{ datos.confirmado }}
              </div>
              <hr class="mt-2" />
              <div class="mt-2 text-gray-600 text-xs">
                Datos adicionales
              </div>
              <div>
                <label class="font-medium">Domicilio Pagado: </label>
                {{ datos.domicilioPagado ? 'SI' : 'NO' }}
              </div>
              <div>
                <label class="font-medium">Marca del vehículo: </label>
                {{ datos.marcaCarro }}
              </div>
              <div>
                <label class="font-medium">Modelo del vehículo: </label>
                {{ datos.modelo }}
              </div>
              <div>
                <label class="font-medium">Kilometraje del vehículo: </label>
                {{ datos.kilometraje }}
              </div>
              <div>
                <label class="font-medium">Descripción del usuario: </label>
                {{ datos.descripcion }}
              </div>
            </div>
            <label for="obs" class="form-label font-medium mt-2"
              >Observaciones</label
            >
            <textarea
              id="obs"
              name="Observaciones"
              class="form-control"
              cols="30"
              rows="5"
              :ref="'servicio' + i"
              :value="datos.observaciones"
            ></textarea>
            <button
              class="btn btn-outline-secondary py-1 px-2"
              @click="editarFlujo(datos, i)"
            >
              <Edit2Icon class="w-4 h-4 mr-2" /> Actualizar
              <LoadingIcon
                v-if="loading"
                icon="oval"
                color="blue"
                class="w-4 h-4 ml-2"
              />
            </button>
          </div>
        </div>
      </div>
      <!-- END: Users Layout -->
      <!-- BEGIN: Pagination -->
      <!-- <div
        class="intro-y col-span-12 flex flex-wrap sm:flex-row sm:flex-nowrap items-center"
      >
        <ul class="pagination">
          <li>
            <a class="pagination__link" href="">
              <ChevronsLeftIcon class="w-4 h-4" />
            </a>
          </li>
          <li>
            <a class="pagination__link" href="">
              <ChevronLeftIcon class="w-4 h-4" />
            </a>
          </li>
          <li>
            <a class="pagination__link" href="">...</a>
          </li>
          <li>
            <a class="pagination__link" href="">1</a>
          </li>
          <li>
            <a class="pagination__link pagination__link--active" href="">2</a>
          </li>
          <li>
            <a class="pagination__link" href="">3</a>
          </li>
          <li>
            <a class="pagination__link" href="">...</a>
          </li>
          <li>
            <a class="pagination__link" href="">
              <ChevronRightIcon class="w-4 h-4" />
            </a>
          </li>
          <li>
            <a class="pagination__link" href="">
              <ChevronsRightIcon class="w-4 h-4" />
            </a>
          </li>
        </ul>
        <select class="w-20 form-select box mt-3 sm:mt-0">
          <option>10</option>
          <option>25</option>
          <option>35</option>
          <option>50</option>
        </select>
      </div> -->
      <!-- END: Pagination -->
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import { mapActions, mapGetters } from 'vuex'
/* import feather from 'feather-icons'
import Tabulator from 'tabulator-tables' */

export default defineComponent({
  data() {
    return {
      servicios: [],
      domicilios: [],
      loading: false
    }
  },
  methods: {
    ...mapActions([
      'getServiciosStore',
      'agregarObservacion',
      'deleteDomicilio',
      'deleteServicio'
    ]), // Esto llama al metodo en el store que trae los usuarios
    async initTabulator() {
      const doc = await this.gettersServiciosStore.collectionGroup('servicios')
      doc.onSnapshot(
        docSnapshot => {
          const changes = docSnapshot.docChanges()
          this.servicios = []
          changes.forEach(docChange => {
            const newDoc = docChange.doc
            this.servicios.push({
              id: newDoc.id,
              tipo: 'Taller',
              ...newDoc.data()
            })
          })
        },
        err => {
          console.log(`Encountered error: ${err}`)
        }
      )
      const docDomicilios = await this.gettersServiciosStore.collectionGroup(
        'domicilios'
      )
      docDomicilios.onSnapshot(
        docSnapshot => {
          const changes = docSnapshot.docChanges()
          this.domicilios = []
          changes.forEach(docChange => {
            const newDoc = docChange.doc
            this.domicilios.push({
              id: newDoc.id,
              tipo: 'Domicilio',
              ...newDoc.data()
            })
          })
        },
        err => {
          console.log(`Encountered error: ${err}`)
        }
      )
    },
    async editarFlujo(data, i) {
      this.loading = true
      const textarea = this.$refs['servicio' + i].value
      this.agregarObservacion({
        ...data,
        observaciones: textarea
      })
      this.loading = false
      await this.getServiciosStore()
      this.initTabulator()
    },
    definirColor(estado) {
      switch (estado) {
        case 'CREADO':
          return '#ffff006b'
        case 'TOMADO':
          return '#00800038'
        case 'CANCELADO':
          return '#ff00002e'
      }
    },
    async eliminar(datos) {
      console.log(datos)
      if (datos.tipo == 'Domicilio') {
        this.deleteDomicilio(datos)
      } else if (datos.tipo == 'Taller') {
        this.deleteServicio(datos)
      }
      await this.initTabulator()
    }
  },
  computed: {
    ...mapGetters(['gettersServiciosStore', 'gettersDomiciliosStore']),
    flujodatos() {
      return this.servicios.concat(this.domicilios).sort(function(a, b) {
        return new Date(b.fecha) - new Date(a.fecha)
      })
    }
  },
  async mounted() {
    await this.getServiciosStore()
    this.initTabulator()
  }
})
/*  this.tabulator = new Tabulator(this.$refs.tableRef, {
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
        data: this.flujodatos,
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
            title: 'ESTADO',
            minWidth: 200,
            responsive: 0,
            field: 'estado',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'FECHA',
            minWidth: 200,
            field: 'fecha',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'HORA',
            minWidth: 200,
            field: 'hora',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'USUARIO',
            minWidth: 200,
            field: 'nombreUsuario',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'TELEFONO',
            minWidth: 200,
            field: 'telefonoUsuario',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'TALLER',
            minWidth: 200,
            field: 'nombreTaller',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'CÓDIGO',
            minWidth: 200,
            field: 'codigo',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'SERVICIO',
            minWidth: 200,
            field: 'tipoDeServicio',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'VALOR',
            minWidth: 200,
            field: 'valorServicio',
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
            title: 'CIUDAD',
            minWidth: 200,
            field: 'ciudadMunicipio',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'CONFIRMADO',
            minWidth: 200,
            field: 'confirmado',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter(cell) {
              return `<div class="flex items-center lg:justify-center ${
                cell.getData().confirmado ? 'text-theme-10' : 'text-theme-24'
              }">
                ${cell.getData().confirmado ? 'SI' : 'NO'}
              </div>`
            }
          },
          {
            title: 'ACTIONS',
            minWidth: 200,
            field: 'actions',
            responsive: 1,
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false,
            formatter() {
              const a = cash(`<div class="flex lg:justify-center items-center">
                <a class="flex items-center mr-3" href="javascript:;">
                  <i data-feather="check-square" class="w-4 h-4 mr-1"></i> Edit
                </a>
                <a class="flex items-center text-theme-24" href="javascript:;">
                  <i data-feather="trash-2" class="w-4 h-4 mr-1"></i> Delete
                </a>
              </div>`)
              cash(a).on('click', function() {
                // On click actions
              })

              return a[0]
            }
          },

          // For print format
          {
            title: 'PRODUCT NAME',
            field: 'name',
            visible: false,
            print: true,
            download: true
          },
          {
            title: 'CATEGORY',
            field: 'category',
            visible: false,
            print: true,
            download: true
          },
          {
            title: 'REMAINING STOCK',
            field: 'remaining_stock',
            visible: false,
            print: true,
            download: true
          },
          {
            title: 'STATUS',
            field: 'status',
            visible: false,
            print: true,
            download: true,
            formatterPrint(cell) {
              return cell.getValue() ? 'Active' : 'Inactive'
            }
          },
          {
            title: 'IMAGE 1',
            field: 'images',
            visible: false,
            print: true,
            download: true,
            formatterPrint(cell) {
              return cell.getValue()[0]
            }
          },
          {
            title: 'IMAGE 2',
            field: 'images',
            visible: false,
            print: true,
            download: true,
            formatterPrint(cell) {
              return cell.getValue()[1]
            }
          },
          {
            title: 'IMAGE 3',
            field: 'images',
            visible: false,
            print: true,
            download: true,
            formatterPrint(cell) {
              return cell.getValue()[2]
            }
          }
        ]
      }) */
</script>
