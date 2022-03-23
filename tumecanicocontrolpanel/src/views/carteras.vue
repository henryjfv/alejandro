<template>
  <div>
    <div class="intro-y flex flex-col sm:flex-row items-center mt-8">
      <h2 class="text-lg font-medium mr-auto">Carteras</h2>
    </div>
    <!-- BEGIN: HTML Table Data -->
    <div class="intro-y box p-5 mt-5">
      <div class="overflow-x-auto scrollbar-hidden">
        <div
          id="tabulator"
          ref="tableRef"
          class="mt-5 table-report table-report--tabulator"
        ></div>
      </div>
    </div>
    <!-- END: HTML Table Data -->
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
      carteras: []
    }
  },
  methods: {
    ...mapActions(['getCarterasStore']), // Esto llama al metodo en el store que trae los usuarios
    initTabulator() {
      this.carteras = this.gettersCarterasStore
      this.tabulator = new Tabulator(this.$refs.tableRef, {
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
        data: this.carteras,
        columns: [
          /*           {
            formatter: 'responsiveCollapse',
            width: 40,
            minWidth: 30,
            hozAlign: 'center',
            resizable: false,
            headerSort: false
          },
 */
          // For HTML table
          {
            title: 'ID SERVICIO',
            minWidth: 200,
            responsive: 0,
            field: 'idServicioPrestado',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'TIPO DE CUENTA',
            minWidth: 200,
            field: 'TipoCuenta',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'ESTADO CARTERA',
            minWidth: 200,
            field: 'EstadoCartera',
            hozAlign: 'center',
            vertAlign: 'middle',
            print: false,
            download: false
          },
          {
            title: 'VALOR',
            minWidth: 200,
            field: 'valor',
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
          }
        ]
      })
    }
  },
  computed: {
    ...mapGetters(['gettersCarterasStore'])
  },
  async mounted() {
    await this.getCarterasStore()
    this.initTabulator()
  }
})
</script>
