<template>
  <div>
    <!-- Modal Component -->
    <b-modal id="modal2" title="Transaction Hash" hide-footer>


      <a style="font-size: 16px;word-break: break-word;" v-bind:href="'https://rinkeby.etherscan.io/tx/'+buyHash"
         target="_blank">
        {{buyHash}}
      </a>
      <br/>
      <small>
        {{$lang.messages.m1}}
      </small>
    </b-modal>
  <div class="row">

    <div v-if="game.period" class="col-sm-4">
      <h1 v-bind:style="{ color: '#'+game.period.winnerHash.substring(2, 8) }">#{{roundId}}</h1>
      <a v-bind:href="'https://rinkeby.etherscan.io/address/'+game.address" target="_blank"
         style="word-break: break-word; font-size: 10px">{{game.address}}</a>
      <div class="badge badge-success" v-if="game.currentPeriod == roundId">{{$lang.messages.currentRound}}
      </div>
      <div class="badge badge-warning" v-else-if="game.currentPeriod > roundId">{{$lang.messages.roundFinished}}</div>
      <div class="badge badge-error" v-else="">{{$lang.messages.roundNotBegun}}</div>

      <div> {{game.period.startDate | sdate}} {{game.period.startDate | stime}}</div>
      <div></div>


    </div>
    <div class="col-sm-3">

      <div v-if="game.period">
        <h3> {{$lang.messages.ticketPrice}}
        </h3>
        <h3 v-bind:style="{ color: '#'+game.period.winnerHash.substring(2, 8) }">
          {{game.ticketPrice | eth}}</h3>


        <div style="margin-top: 42px" v-if="game.currentPeriod != roundId">
          <button type="button" class="btn btn-primary" v-on:click="goToRound(gameId,game.currentPeriod)">
            {{$lang.messages.m3}} #{{game.currentPeriod | int}}
          </button>
        </div>


      </div>
      <form v-if="game.currentPeriod == roundId" style="margin-top: 20px" class="form-inline">
        <div>


          <!-- Modal Component -->
          <b-modal id="modal1" title="Your Magic Words" @ok="buyTicket" @shown="focusMyElement">
            <div class="form-group">

              <input ref="focusThis" style="width: 100%" type="email" class="form-control border-primary"
                     v-model="nonce" aria-describedby="nonce" placeholder="Any Symbols">
              <!--<small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>-->
            </div>
          </b-modal>
        </div>

        <b-btn v-b-modal.modal1 type="button" variant="primary" size="lg"
               autocomplete="off">
          Win Now!
        </b-btn>

      </form>

      <!--<p v-if="game.period" class="card-text">
        &lt;!&ndash;Куплено <br/> <b>{{game.period.ticketAmount | int}} билета</b>&ndash;&gt;
        <br/>
      </p>-->

      <div>

      </div>
    </div>
    <div class="col-sm-5">

      <div class=" " v-if="game.period">

        <div v-if="game.tickets && !game.tickets.length">
        <h3>
          {{$lang.messages.m5}}
        </h3>
          <p></p>
        </div>

        <div v-if="game.tickets && game.tickets.length">

          <h3 style="" v-if="game.currentPeriod == roundId">

            {{$lang.messages.m4}}

          </h3>
          <h3 v-if="game.currentPeriod > roundId">
            {{$lang.messages.winner}}
          </h3>

          <div style="margin-top: 20px; white-space: nowrap">
            <div style="float:left; width: 80px; margin-top: 2px;">
              <cube :hash="game.period.winnerHash"></cube>
            </div>
            <div style="margin-left: 80px">

              <div style="word-break: break-word; font-size: 12px">


                <div style="vertical-align: top"
                     v-bind:style="{ color: '#'+game.period.winnerHash.substring(2, 8) }">
                  {{game.period.winnerHash.substring(0, 31)}}...{{game.period.winnerHash.substring(58, 66)}}
                </div>
              </div>
              <div style="  font-size: 12px; white-space: nowrap">
                <a
                  v-bind:href="'https://rinkeby.etherscan.io/address/'+game.period.winnerAddress">
                  {{game.period.winnerAddress}}
                </a>
              </div>
            </div>

          </div>

          <div style="margin-top: 20px" v-if="game.period && game.period.tx && game.currentPeriod > roundId">

            <h3>{{$lang.messages.gain}}</h3>


            <h3 v-bind:style="{ color: '#'+game.period.winnerHash.substring(2, 8) }">
              {{game.period.tx.args.reward | eth}}</h3>

          </div>

          <div v-if="game.currentPeriod == roundId">
            <h5 style="margin-top: 20px">
                         <span v-bind:style="{ color: '#'+game.period.winnerHash.substring(2, 8) }"
                         >{{game.maxTicketAmount - game.period.ticketAmount | int}}</span>
              {{$lang.messages.stock}}

            </h5>
            <h5>{{$lang.messages.bank}} <span
              v-bind:style="{ color: '#'+game.period.winnerHash.substring(2, 8) }">{{game.period.raised | eth}}</span>
            </h5>
          </div>


        </div>


      </div>
    </div>
    <div class="col-sm-12">


    </div>

  </div>
  </div>
</template>
<script>
  import DownloadMetamask from 'components/DownloadMetamask'
  import Cube from 'components/Cube'


  import Metamask from 'services/Metamask';

  const MetamaskService = new Metamask();

  export default {
    components: {
      DownloadMetamask,
      Cube
    },
    created: function () {
      this.init();
    },

    props: ['game','gameId','roundId'],

    data: function () {
      return {
        level: -1,
        nonce: '',
        buyHash: ''
      }
    },


    methods: {
      init: function () {
        let self = this;
       // self.level = MetamaskService.detectLevel();
      },
      goToRound: function (gameId, roundId) {

        router.push({path: '/game/' + gameId + '/' + roundId});
        //router.go();

        return true;


      },
      focusMyElement (e) {
        this.$refs.focusThis.focus()
      },


      buyTicket: function () {
        let self = this;


        MetamaskService.games().byTicket(self.gameId, self.nonce, self.game.currentPeriod, self.game.ticketPrice).then(function (r) {

          self.buyHash = r;

          self.$root.$emit('bv::show::modal', 'modal2');

          self.nonce = '';

        }).catch(function (e) {
          console.error(e);
        });

        return false;
      }


    }
  }
</script>
<style scoped="">
  h1 {
    font-size: 114px;
    line-height: 114px;
  }
</style>
