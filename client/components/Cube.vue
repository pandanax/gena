<template>
  <div class="cube-outer">

      <!--<div v-bind:style="{ 'background-color': '#'+hash.substring(8, 14) }" class="cube-in"></div>-->
      <div v-bind:style="{ 'background-color': '#'+hash.substring(2, 8) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(14, 20) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(8, 14) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(20, 26) }" class="cube-in"></div>
     <!-- <div v-bind:style="{ 'background-color': '#'+hash.substring(26, 32) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(32, 38) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(38, 44) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(44, 50) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(50, 56) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(56, 62) }" class="cube-in"></div>
      <div v-bind:style="{ 'background-color': '#'+hash.substring(60, 66) }" class="cube-in"></div>-->
    <!--<div v-bind:style="{ 'background-color': '#'+hash.substring(50, 56) }" class="cube-in"></div>-->




    <!--<div v-bind:style="{ 'color': '#' + hash.substring(2, 8)}" class="circle-in">
        {{hash.substring(0, 10)}}
      </div>-->
  </div>
</template>
<script>
  export default {

    props: ['hash'],

    created: function () {
       this.init();
    },
    methods: {
        init: function () {

        }
    }
  }
</script>
<style>
  .cube-outer {
    width: 64px;
    height:32px;
    display: inline-block;
    /*margin-right: 20px;*/
    vertical-align: middle;
    position: relative;

    overflow: hidden;
  }
  .cube-in {
    width: 50%;
    height: 50%;
    float: left;

    /*box-shadow: inset 0px 0px 10px rgba(0,0,0,0.2);*/


  }

  .circle-in {
    position: absolute;
    top:20px;
    left: 0px;
    z-index: 1;
    font-size: 9px;
    width: 100%;
    line-height: 9px;
    vertical-align: top;
    text-align: center;



    /*box-shadow: inset 0px 0px 10px rgba(0,0,0,0.2);*/

  }




</style>
