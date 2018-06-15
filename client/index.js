//import '../node_modules/bootstrap/dist/css/bootstrap.css'
import '../node_modules/bootstrap/dist/css/bootstrap.css'
import './promise-polyfill'
import { app } from './app'



// Enable progressive web app support (with offline-plugin)
if (process.env.NODE_ENV === 'production') {
  require('./pwa')
}

app.$mount('#app')


