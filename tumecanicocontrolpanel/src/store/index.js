import { createStore } from 'vuex'
import main from './main'
import sideMenu from './side-menu'
import simpleMenu from './simple-menu'
import topMenu from './top-menu'
import tumecanico from './tumecanicoenlinea-store'

const store = createStore({
  modules: {
    main,
    sideMenu,
    simpleMenu,
    topMenu,
    tumecanico
  }
})

export function useStore() {
  return store
}

export default store
