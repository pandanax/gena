<template>
  <div class="container-fluid mt-4">

    <div v-if="level < 2">
      <download-metamask></download-metamask>
    </div>

    <div v-if="level == 2 && registered">
      <div class="">

        <div class="card flex-md-row mb-4 box-shadow h-md-250 mr-3">
          <div class="card-body">


            <form class="mt-3" v-on:submit="pushFundsInsteadChild">
              <div class="form-group">

                <label>Do work instead your children</label>
                <input required class="form-control" placeholder="child address"
                       name="childAddress"
                       id="childInstead" v-model="childInstead"/>

                <small v-if="childInsteadTx">
                  Tx Hash: {{childInsteadTx}}
                </small>
              </div>
              <div>
                <button :disabled="(childInsteadTx)?true:false" type="submit" class="btn btn-primary">HELP CHILD
                </button>
              </div>

            </form>


          </div>

        </div>

        <div class="card flex-md-row mb-4 box-shadow h-md-250 mr-3">
          <div class="card-body">


            <form class="mt-3" v-on:submit="transferUser">
              <div class="form-group">

                <label>Change My Address</label>
                <input required class="form-control" placeholder="new address"
                       name="newAddress"
                       id="newAddress" v-model="newAddress"/>

                <small v-if="newAddressTx">
                  Tx Hash: {{newAddressTx}}
                </small>
              </div>
              <div>
                <button :disabled="(newAddressTx)?true:false" type="submit" class="btn btn-primary">CHANGE MY ADDRESS
                </button>
              </div>

            </form>


          </div>

        </div>

        <div class="card flex-md-row mb-4 box-shadow h-md-250 mr-3" v-if="genesis == acc || parent == genesis">
          <div class="card-body">


            <form class="mt-3" v-on:submit="killByDeadline" >
              <div class="form-group">

                <label>Delete User</label>
                <input required class="form-control" placeholder="address"
                       name="Address"
                       id="Address" v-model="deletedAddress"/>

                <small v-if="deletedAddressTx">
                  Tx Hash: {{deletedAddressTx}}
                </small>
              </div>
              <div>
                <button :disabled="(deletedAddressTx)?true:false" type="submit" class="btn btn-primary">DELETE
                </button>
              </div>

            </form>


          </div>

        </div>


      </div>


    </div>

  </div>
</template>
<script>

  import DownloadMetamask from 'components/DownloadMetamask'

  import Metamask from 'services/Metamask';

  const MetamaskService = new Metamask();

  export default {
    components: {
      DownloadMetamask,
    },
    created: function () {
      this.init();
    },

    data: function () {
      return {
        level: -1,
        acc: '',
        myAvailableFunds: '',
        children: [],
        parent: '',
        payment: '',
        paymentAmount: '',
        paymentPlaceholder: '',
        gain: '',
        gainAmount: 0,
        nickname: '',
        myNickName: '',
        registered: false,
        genesis: null,
        showSetNickForm: false,
        newNickName: '',
        newNickNameTx: '',
        getMineTx: '',
        registerTx: '',
        updateActivityTx: '',
        lastActivity: 0,
        deadline: 0,


        childInstead: '',
        childInsteadTx: '',
        newAddress: '',
        newAddressTx: '',
        deletedAddress: '',
        deletedAddressTx: ''
      }
    },


    methods: {
      pushFundsInsteadChild(e){

        let self = this
        e.preventDefault()
        MetamaskService.genesis().pushFundsInsteadChild(self.childInstead).then(function (r) {
          self.childInsteadTx = r;
        })
      },

      transferUser(e){

        let self = this
        e.preventDefault()
        MetamaskService.genesis().transferUser(self.newAddress).then(function (r) {
          self.newAddressTx = r;
        })
      },

      killByDeadline(e){

        let self = this
        e.preventDefault()
        MetamaskService.genesis().killByDeadline(self.deletedAddress).then(function (r) {
          self.deletedAddressTx = r;
        })
      },

      init: function () {
        let self = this;
        self.level = MetamaskService.detectLevel();

        self.acc = MetamaskService.genesis().getAccount();

        MetamaskService.genesis().getField('genesis').then(function (r) {
          self.genesis = r;

        })
        MetamaskService.genesis().getField('isNotRegistered', [self.acc]).then(function (r) {
          self.registered = !r;
        })


        MetamaskService.genesis().getField('parents', [self.acc]).then(function (r) {
          self.parent = r;
        })


        MetamaskService.genesis().getField('payments', [self.acc]).then(function (r) {
          self.gain = r;
          self.gainAmount = r / Math.pow(10, 18)
        }).catch(console.error)

        MetamaskService.genesis().getParent(self.acc).then(function (r) {
          self.parent = r;
        });

        MetamaskService.genesis().getField('myAvailableFunds').then(function (r) {
          self.myAvailableFunds = r;
        });

        MetamaskService.genesis().getField('nicknames', [self.acc]).then(function (r) {
          self.myNickName = r;
        });
        MetamaskService.genesis().getField('lastActivity', [self.acc]).then(function (r) {
          self.lastActivity = r;
          MetamaskService.genesis().getField('deadLine').then(function (r) {
            self.deadline = r * 1 + self.lastActivity * 1;
          });
        });


      }
    }
  }
</script>
