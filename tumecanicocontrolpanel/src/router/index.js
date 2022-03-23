import { createRouter, createWebHistory } from 'vue-router'
import SideMenu from '../layouts/side-menu/Main.vue'
import ErrorPage from '../views/error-page/Main.vue'
import Usuarios from '../views/usuarios.vue'
import Talleres from '../views/talleres.vue'
import Mecanicos from '../views/mecanicos.vue'
import Carteras from '../views/carteras.vue'
import Servicios from '../views/servicios.vue'
import Configuracion from '../views/configuracion.vue'
import debug from '../views/debugzone.vue'

const routes = [
  {
    path: '/',
    component: SideMenu,
    children: [
      {
        path: '/usuarios',
        name: 'Usuarios',
        component: Usuarios
      },
      {
        path: '/mecanicos',
        name: 'Mecanicos',
        component: Mecanicos
      },
      {
        path: '/talleres',
        name: 'Talleres',
        component: Talleres
      },
      {
        path: '/carteras',
        name: 'Carteras',
        component: Carteras
      },
      {
        path: '/configuracion',
        name: 'Configuracion',
        component: Configuracion
      },
      {
        path: '/',
        name: 'Servicios',
        component: Servicios
      },
      {
        path: '/debugzone',
        name: 'debugzone',
        component: debug
      }
    ]
  },
  {
    path: '/error-page',
    name: 'error-page',
    component: ErrorPage
  },
  {
    path: '/:pathMatch(.*)*',
    component: ErrorPage
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
  scrollBehavior(to, from, savedPosition) {
    return savedPosition || { left: 0, top: 0 }
  }
})

export default router
