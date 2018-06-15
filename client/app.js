import Vue from 'vue'
import { sync } from 'vuex-router-sync'
import App from './components/App'
import router from './router'
import store from './store'
import filter from './filter'
import localization from 'vuejs-localization'

import BootstrapVue from 'bootstrap-vue'

localization.requireAll(require.context('./lang', true, /\.js$/));


Vue.use(BootstrapVue);
Vue.use(localization);

sync(store, router)

const app = new Vue({
  router,
  store,
  filter,
  localization,
  ...App
})

export { app, router, store, filter, localization}


