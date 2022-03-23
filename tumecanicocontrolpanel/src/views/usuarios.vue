<template>
  <div>
    <h2 class="intro-y text-lg font-medium mt-10">Usuarios</h2>
    <div class="grid grid-cols-12 gap-6 mt-5">
      <div
        class="intro-y col-span-12 flex flex-wrap sm:flex-nowrap items-center mt-2"
      >
        <button class="btn btn-primary shadow-md mr-2" @click="showModal">
          Nuevo usuario
        </button>
        <div class="hidden md:block mx-auto text-gray-600">
          {{ usuarios.length }} registros
        </div>
        <div class="w-full sm:w-auto mt-3 sm:mt-0 sm:ml-auto md:ml-0">
          <div class="w-56 relative text-gray-700 dark:text-gray-300">
            <input
              name="nombre"
              type="text"
              class="form-control w-56 box pr-10 placeholder-theme-8"
              placeholder="Buscar nombre..."
              @keydown.enter.prevent
              v-model="buscar"
              autocomplete="off"
            />
            <SearchIcon
              class="w-4 h-4 absolute my-auto inset-y-0 mr-3 right-0"
            />
          </div>
        </div>
      </div>
      <!-- BEGIN: Users Layout -->
      <div
        v-for="(item, i) in usuarios"
        :key="i"
        class="intro-y col-span-12 md:col-span-6 lg:col-span-4"
      >
        <div class="box">
          <div class="flex items-start px-5 pt-5">
            <div class="w-full flex flex-col lg:flex-row items-center">
              <!--               <div class="w-16 h-16 image-fit">
                <img
                  alt="Placeholder"
                  class="rounded-full"
                  src="@/assets/images/placeholders/200x200.jpg"
                />
              </div> -->
              <div class="lg:ml-4 text-center lg:text-left mt-3 lg:mt-0">
                <a href="" class="font-medium">{{ item.nombres }}</a>
                <div class="text-gray-600 text-xs mt-0.5">
                  {{ item.isLogin ? 'Activo' : 'Inactivo' }}
                </div>
                <div class="text-gray-600 text-xs mt-0.5">
                  Telefono {{ item.telefono }}
                </div>
              </div>
            </div>
            <div class="absolute right-0 top-0 mr-5 mt-3 dropdown">
              <a
                class="dropdown-toggle w-5 h-5 block"
                href="javascript:;"
                aria-expanded="false"
              >
                <MoreHorizontalIcon
                  class="w-5 h-5 text-gray-600 dark:text-gray-300"
                />
              </a>
              <div class="dropdown-menu w-40">
                <div class="dropdown-menu__content box dark:bg-dark-1 p-2">
                  <a
                    @click="editarUsuario(item)"
                    class="flex items-center block p-2 transition duration-300 ease-in-out bg-white dark:bg-dark-1 hover:bg-gray-200 dark:hover:bg-dark-2 rounded-md cursor-pointer"
                  >
                    <Edit2Icon class="w-4 h-4 mr-2" /> Editar
                  </a>
                  <a
                    @click="mensajeEliminar(item)"
                    class="flex items-center block p-2 transition duration-300 ease-in-out bg-white dark:bg-dark-1 hover:bg-gray-200 dark:hover:bg-dark-2 rounded-md cursor-pointer"
                  >
                    <TrashIcon class="w-4 h-4 mr-2" /> Eliminar
                  </a>
                </div>
              </div>
            </div>
          </div>
          <div class="text-center lg:text-left p-5">
            <div
              class="flex items-center justify-center lg:justify-start text-gray-600 mt-5"
            >
              <MailIcon class="w-3 h-3 mr-2" />
              {{ item.email }}
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- BEGIN: Modal Content -->
    <div id="modal-usuarios" class="modal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <!-- BEGIN: Modal Header -->
          <div class="modal-header">
            <h2 class="font-medium text-base mr-auto">
              {{ editarFlag ? 'Editar' : 'Nuevo' }} usuario
            </h2>
          </div>
          <!-- END: Modal Header -->
          <!-- BEGIN: Modal Body -->
          <div class="modal-body grid grid-cols-12 gap-4 gap-y-3">
            <div class="col-span-12 sm:col-span-6">
              <label for="modal-form-1" class="form-label">Email</label>
              <input
                id="modal-form-1"
                type="email"
                class="form-control"
                placeholder="example@gmail.com"
                v-model="email"
                :disabled="editarFlag"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="modal-form-2" class="form-label">Nombres</label>
              <input
                id="modal-form-2"
                type="text"
                class="form-control"
                placeholder="Nombres"
                v-model="nombres"
              />
            </div>
            <div class="col-span-12 sm:col-span-6">
              <label for="modal-form-3" class="form-label">Teléfono</label>
              <input
                id="modal-form-3"
                type="tel"
                class="form-control"
                placeholder="Telefono"
                v-model="telefono"
              />
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
              @click="editarFlag ? updateUser() : crearUsuario()"
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
                @click="eliminarUsuario()"
              >
                Borrar
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- END: Modal Content -->
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import { mapActions, mapGetters } from 'vuex'

export default defineComponent({
  data() {
    return {
      usuarios: [],
      oldUsuarios: [],
      email: '',
      password: '',
      nombres: '',
      telefono: '',
      usuarioSeleccionado: {},
      editarFlag: false,
      buscar: ''
    }
  },
  methods: {
    ...mapActions([
      'getUsuariosStore',
      'setUsuariosStore',
      'deleteUsuario',
      'setDataUser'
    ]), // Esto llama al metodo en el store que trae los usuarios
    initTabulator() {
      this.usuarios = this.gettersUsuariosStore.sort()
      this.oldUsuarios = this.usuarios
    },
    showModal() {
      this.editarFlag = false
      cash('#modal-usuarios').modal('show')
    },
    cancelModal() {
      this.email = ''
      this.nombres = ''
      this.password = ''
      this.telefono = ''
      cash('#modal-usuarios').modal('hide')
    },
    async crearUsuario() {
      await this.setUsuariosStore({
        email: this.email.trim(),
        nombres: this.nombres.trim(),
        password: this.password.trim(),
        telefono: this.telefono.trim()
      })
      await this.getUsuariosStore()
      this.initTabulator()
      this.cancelModal()
    },
    mensajeEliminar(data) {
      this.usuarioSeleccionado = data
      cash('#delete-modal').modal('show')
    },
    async eliminarUsuario() {
      this.deleteUsuario(this.usuarioSeleccionado)
      await this.getUsuariosStore()
      this.initTabulator()
      cash('#delete-modal').modal('hide')
    },
    async editarUsuario(data) {
      this.editarFlag = true
      this.email = data.email
      this.nombres = data.nombres
      this.password = data.password
      this.telefono = data.telefono
      this.usuarioSeleccionado = data
      cash('#modal-usuarios').modal('show')
    },
    async updateUser() {
      this.setDataUser({
        uid: this.usuarioSeleccionado.uid,
        email: this.email.trim(),
        nombres: this.nombres.trim(),
        password: this.password.trim(),
        telefono: this.telefono.trim()
      })
      await this.getUsuariosStore()
      this.initTabulator()
      this.cancelModal()
    }
  },
  computed: {
    ...mapGetters(['gettersUsuariosStore'])
  },
  watch: {
    buscar(newValue, oldValue) {
      let usuariosTemp = []
      if (newValue) {
        usuariosTemp = this.usuarios.filter(usuario =>
          usuario.nombres.toLowerCase().includes(this.buscar.toLowerCase())
        )
      } else if (newValue == '') {
        usuariosTemp = this.oldUsuarios
      }
      this.usuarios = usuariosTemp
    }
  },
  async mounted() {
    await this.getUsuariosStore()
    this.initTabulator()
  }
})
</script>
