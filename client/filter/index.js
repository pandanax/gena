import Vue from 'vue'

Vue.filter('capitalize', function (value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
});
Vue.filter('eth', function (value) {

  return value/1000000000000000000 + ' ETH';

});
Vue.filter('trm', function (value) {

  return value/1000000000000000000 + ' TRM';

});
Vue.filter('int', function (value) {

  return value*1;

});
Vue.filter('bytes', function (value) {

  return value.substring(0,6);

});
Vue.filter('sdate', function (value) {
  if (!value) return ''
  value = new Date(value * 1000);
  let fy = value.getFullYear();
  let m = value.getMonth() + 1;
  if (m < 10) {
    m = '0' + m;
  }
  let d = value.getDate();
  if (d < 10) {
    d = '0'+d;
  }
  return d + '.' + m +'.'+fy;
})

Vue.filter('stime', function (_value) {
  if (!_value) return ''
  let value = new Date(_value * 1000);

  //console.log('vv', _value, _value*1000, value.getTime(), value);



  let m = value.getMinutes();

  if (m < 10) {
    m = '0'+m;
  }



  let h = value.getHours();

  if (h < 10) {
    h = '0'+h;
  }
  //let tz = value.getTimezoneOffset();


  return h+':'+m;
})
