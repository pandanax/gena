<template>
  <div class="body">

    <div class="container-fluid mt-4">


      <div>
        <div class="card flex-md-row mb-4 box-shadow h-md-250">
          <div class="card-body">

            <h3>Your referral link</h3>
            <input class="form-control" v-model="link"/>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import EtherData from "ether";
  import Metamask from 'services/Metamask';
  import uiConfig from 'uiConfig';

  const MetamaskService = new Metamask();

  export default {
    components: {},
    data: function () {
      return {
        contract: '',
        level: -1,
        acc: '',
        link: '',
        conf: {}
      }
    },
    created: function () {
      this.init();
    },
    methods: {
      init() {
        let self  = this

        self.level = MetamaskService.detectLevel();

        self.acc = MetamaskService.genesis().getAccount();

        self.conf = uiConfig;

        self.link = uiConfig.mainUrl + '?r=' + self.acc
      }
    }
  }
</script>
