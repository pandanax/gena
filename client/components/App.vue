<template>
  <div id="app">
    <div class="container-fluid d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom box-shadow">

      <h5 class="my-0 mr-md-auto font-weight-normal"><a href="#/">Genesis</a></h5>
      <navigation></navigation>
      <!--<a class="btn btn-outline-primary" href="#/profile">Profile</a>-->
    </div>
    <router-view></router-view>
  </div>
</template>

<style>

  body {
    background: lightgrey;
  }

</style>
<script>
  import Navigation from 'components/Navigation'
  import detectLang from 'detect-browser-language'


  export default {
    components: {
      Navigation
    },
    created: function () {

      var url = new URL(location.href);
      var r = url.searchParams.get("r");

      if (r) {
        localStorage.setItem('ref', r);
      }


      var s = detectLang();
      var lng = s.substring(0, 2).toLowerCase();

      if (lng == 'cn') {
        this.$lang.setLang('cn')
      } else if (lng == 'ru') {
        this.$lang.setLang('ru')
      } else {
        this.$lang.setLang('en')
      }


    }

  }
</script>
