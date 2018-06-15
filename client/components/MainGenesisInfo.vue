<template>
  <div class="container-fluid mt-4">

    <div v-if="level < 2">
      <download-metamask></download-metamask>
    </div>
    <div v-if="level == 2 && !registered">
      <div class="card flex-md-row mb-4 box-shadow h-md-250">
        <div class="card-body">
          <div class="clearfix">
            <h3 class="mb-3 ">
              Hello! Please Sign Up!
            </h3>
            <p>
              Enter desired parent address
            </p>
            <form>

              <div class="form-group">

                <input class="form-control" placeholder="parent address" v-model="parentAddr"/>
              </div>
              <button :disabled="payment || parentAddr == ''" type="button" class="btn btn-primary" v-on:click="join">CHECK</button>
              <button :disabled="!payment || parentAddr == ''" type="button" class="btn btn-default" v-on:click="payment = false; parentAddr = ''">CLEAR</button>


              <div v-if="payment" class="mt-3">
                <hr/>
                <div class="form-group">
                  <h3 class="text-muted">Gain: {{payment | eth}}</h3>
                  <p>It means you can join to Genesis network with purchasing  >= ({{payment | eth}})</p>

                  <div class="form-group">
                    <label>
                     Enter Nickname
                    </label>
                    <input class="form-control" placeholder="nickname" v-model="nickname"/>
                  </div>
                  <div class="form-group">
                    <label>
                      Enter Your Gain (>={{payment | eth}})
                    </label>
                    <input class="form-control" placeholder="gain" v-model="paymentAmount"/>
                  </div>
                  <button :disabled="(registerTx)?true:false" type="button" class="btn btn-success" v-on:click="pay">
                    SIGN UP
                  </button>

                  <div class="" v-if="registerTx">
                    <small>
                      Tx Hash: {{registerTx}}
                    </small>
                  </div>

                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <div v-if="level == 2 && registered">
      <div class="">

        <div class="card flex-md-row mb-4 box-shadow h-md-250 mr-3">
          <div class="card-body">
            <div class="clearfix">
              <h3 class="mb-0 float-left">

                <span v-if="myNickName" class="text-dark">
                {{myNickName}}
              </span>
                <span v-if="!myNickName">
                User_{{acc | bytes}}

              </span>
              </h3>
              <small v-if="!showSetNickForm" v-on:click="showSetNick" class="pt-2 cursor-pointer ml-3 float-left"><a
                class=" text-muted" href="#">edit</a></small>
              <h4 class="text-muted mt-2 float-right">Gain: {{gainAmount}} ETH</h4>

            </div>


            <form v-if="showSetNickForm" class="mt-3" v-on:submit="setNewNicknameAction">
              <div class="form-group">
                <input required class="form-control float-left w-50 mr-2" placeholder="Nickname"
                       name="newNickName"
                       id="newNickName" v-model="newNickName"/>
                <button :disabled="(newNickNameTx)?true:false" type="submit" class="btn btn-primary">SAVE</button>
                <button type="button" v-on:click="showSetNickForm = false" class="btn btn-default">CANCEL</button>
                <div>

                  <small v-if="newNickNameTx">
                    Tx Hash: {{newNickNameTx}} <i class="fa fa-edit"></i>
                  </small>
                </div>
              </div>
            </form>
            <span class="text-muted mt-2 float-right">
              Last Activity: {{lastActivity | sdate}} {{lastActivity | stime}} <br/>
              Deadline: {{deadline | sdate}} {{deadline | stime}}
            </span>


            <strong class="d-inline-block mb-0 text-primary">Your Address: {{acc}}</strong>


            <div class="mb-1 text-muted">Parent Address: {{parent}}</div>


            <div v-if="(new Date()).getTime()/1000 > deadline">
              <div class="text-danger">
                YOUR ACCOUNT HAS EXPIRED {{deadline | sdate}} {{deadline | stime}}!
              </div>
              <form>
                <div class="form-group">
                  <label>Purchase yor gain {{gain | eth}}</label>

                </div>
                <button :disabled="(updateActivityTx)?true:false" class="btn btn-primary" v-on:click="updateActivity">
                  UPDATE ACTIVITY NOW!
                </button>
                <small v-if="updateActivityTx">
                  Tx Hash: {{updateActivityTx}}
                </small>

              </form>
            </div>

          </div>

        </div>
        <!--<div class="card flex-md-row mb-4 box-shadow h-md-250 mr-3 float-left">
          <div class="card-body">
            <h4 class="text-muted mt-3 mb-3">Current Bonus: {{50 + 1 * increaseBonusFlowSize}}%</h4>

            <button class="btn btn-secondary">10 DAYS +10%</button>
            <button class="btn btn-primary">20 DAYS +20%</button>
            <button class="btn btn-success">30 DAYS +30%</button>

          </div>
        </div>-->


        <div class="card flex-md-row mb-4 box-shadow h-md-250 mr-3">
          <div class="card-body">
            <div class="card-text mb-auto" v-if="myAvailableFunds != 0">

              <h4 class="text-muted mt-3 mb-3">Available Funds: {{myAvailableFunds | eth}}</h4>

              <div v-if="(new Date()).getTime()/1000 > deadline" class="text-danger">
                YOUR ACCOUNT HAS EXPIRED {{deadline | sdate}} {{deadline | stime}}!
              </div>
              <div v-else="">
                <button :disabled="(getMineTx)?true:false" v-if="acc != genesis && parent != genesis"
                        class="btn btn-primary"
                        v-on:click="getMine">GET MY FUNDS
                </button>

              </div>

              <button :disabled="(getMineTx)?true:false" v-if="acc == genesis" class="btn btn-primary"
                      v-on:click="getMineGenesis">GET MY FUNDS
              </button>
              <button :disabled="(getMineTx)?true:false" v-if="parent == genesis" class="btn btn-primary"
                      v-on:click="getMineAdmin">GET MY FUNDS
              </button>


            </div>
            <div v-else="" class="text-muted">
              <h4 class="text-muted mt-3 mb-3">Available Funds: {{myAvailableFunds | eth}}</h4>
              <div class="">No available funds yet</div>
            </div>
            <div v-if="getMineTx">
              <small>
                Tx Hash: {{getMineTx}}
              </small>
            </div>


          </div>
        </div>
        <div class="card flex-md-row mb-4 box-shadow h-md-250 mr-3">
          <div class="card-body">
            <h4 class="text-muted mt-3 mb-3">Children amount: {{children.length}}</h4>
            <div class="card-text mb-auto mt-3">

              <div v-if="children.length">You have {{children.length}} children:</div>
              <div v-else="" class="text-muted">You have no children yet</div>

              <span v-for="(c,i) in children" class="text-muted">
                {{c}}<span v-if="i != children.length -1">,</span>
              </span>

            </div>
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
        parent: '',
        myAvailableFunds: '',
        children: [],
        parentAddr: '',
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
        deadline: 0
      }
    },


    methods: {
      showSetNick(e){
        e.preventDefault()
        this.showSetNickForm = true
      },
      getMineGenesis(e){
        let self = this
        e.preventDefault()

        MetamaskService.genesis().getField('getMineGenesis').then(function (r) {
          self.getMineTx = r
          self.setTimerTransaction(self.getMineTx);

        })
      },
      getMineAdmin(e){
        let self = this
        e.preventDefault()

        MetamaskService.genesis().getField('getMineAdmin').then(function (r) {
          self.getMineTx = r
          self.setTimerTransaction(self.getMineTx);

        })
      },
      getMine(e){
        let self = this
        e.preventDefault()

        MetamaskService.genesis().getField('getMine').then(function (r) {
          self.getMineTx = r
          self.setTimerTransaction(self.getMineTx);
        })
      },

      setTimerTransaction(txName){
        let self = this;
        setTimeout(function () {
          MetamaskService.getTx(txName).then(function (r) {
            if (r && r.status) {
              location.reload()
            } else {
              self.setTimerTransaction(txName)
            }
          })
        }, 3000)
      },

      setNewNicknameAction(e){
        e.preventDefault()
        let self = this;
        MetamaskService.genesis().setNickname(self.newNickName).then(function (r) {
          self.newNickName = '';
          self.newNickNameTx = r;
          self.setTimerTransaction(self.newNickNameTx)
          //self.showSetNickForm = false;
        })
      },

      pay(e){
        e.preventDefault()
        let self = this;
        MetamaskService.genesis().register(self.parentAddr, self.nickname, self.paymentAmount * Math.pow(10, 18)).then(function (r) {
          self.registerTx = r;
          self.setTimerTransaction(self.registerTx);

        })
      },
      join(){
        let self = this
        //self.parentAddr
        MetamaskService.genesis().getField('payments', [self.parentAddr]).then(function (r) {
          self.payment = r;
          //self.paymentAmount = r / Math.pow(10, 18)
          self.paymentPlaceholder = r / Math.pow(10, 18)
        }).catch(console.error)
      },

      updateActivity(e){
        let self = this
        e.preventDefault()
        MetamaskService.genesis().updateActivity(self.gain).then(function (r) {
          self.updateActivityTx = r;
          self.setTimerTransaction(self.updateActivityTx);

        })
      },

      init: function () {
        let self = this;

        if (localStorage.getItem('ref')) {
          self.parentAddr = localStorage.getItem('ref')
          self.join()
        }

        self.level = MetamaskService.detectLevel();

        self.acc = MetamaskService.genesis().getAccount();


        MetamaskService.genesis().getField('genesis').then(function (r) {
          self.genesis = r;
        })
        MetamaskService.genesis().getField('isNotRegistered', [self.acc]).then(function (r) {
          self.registered = !r;
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

        function startReadChild(index) {
          MetamaskService.genesis().getField('children', [self.acc, index]).then(function (r) {
            ++index;
            if (r != '0x') {

              self.children.push(r);
              startReadChild(index)
            }


          }).catch(function (e) {

          });
        }

        startReadChild(0);


      }
    }
  }
</script>
