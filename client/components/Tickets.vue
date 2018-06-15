<template>
  <div>
    <div v-if="t && t.hash" class="card" style="margin-bottom: 10px" v-for="t in game.tickets">
      <div class="card-body" v-bind:class="{'winner': game.period.winnerHash == t.hash && game.period.finished}">
        <h5 class="card-title">

          <cube :hash="t.hash"></cube>
          <span v-if="t.number >= 0" style="float: right"> #{{t.number | int}}</span>
          <span v-bind:style="{ color: '#'+t.hash.substring(2, 8) }">{{t.hash}}</span>
        </h5>
        <hr/>
        <div v-if="t.tx && t.tx.args">

          <div style="float: right">{{t.tx.args.when | sdate}} {{t.tx.args.when | stime}}</div>
          <div style="font-size: 12px" class="card-text">        {{$lang.messages.owner}}:
            <a
            v-bind:href="'https://rinkeby.etherscan.io/address/'+t.addr">{{t.addr}}</a>
            <br/>

            {{$lang.messages.transaction}}:
            <a v-bind:href="'https://rinkeby.etherscan.io/tx/'+t.tx.transactionHash"
                           target="_blank">{{t.tx.transactionHash}}</a>
          </div>

        </div>

      </div>
    </div>
  </div>
</template>
<script>
  import Cube from 'components/Cube'

  import Metamask from 'services/Metamask';

  const MetamaskService = new Metamask();

  export default {
    components: {
      Cube
    },
    created: function () {
      this.init();
    },

    props: ['game'],

    data: function () {
      return {
        level: -1
      }
    },


    methods: {
      init: function () {
        let self = this;
      }
    }
  }
</script>
<style>
  .winner:before {
    content: 'Winner';
    position: absolute;
    z-index: 1;
    right: 20px;
    top: -7px;
    font-size: 26px;
    line-height: 120px;
    opacity: 0.2;
  }
</style>
