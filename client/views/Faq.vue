<template>
  <div class="body">

    <div class="container-fluid mt-4">


      <div>
        <div class="card flex-md-row mb-4 box-shadow h-md-250">
          <div class="card-body">

            <ul>
              <li>
                <b>What is Genesis?</b>
                <div>
                  Genesis is reward-network based on Ethereum blockchain. Smart-Contract Address is {{contract}}
                </div>
              </li>

              <li>
                <b>What i need to participate?</b>
                <div>
                  Only your Ethereum wallet. This site is require Metamask browser extension. Also it is possible to use Genesis with MyEthereumWallet or etherescan.io etc without this site
                </div>
              </li>

              <li>
                <b>What is Genesis user?</b>
                <div>
                  Genesis user is node of tree. Every user has children and One Parent. Child gain always greater or equal than parent gain
                </div>
              </li>

              <li>
                <b>What is gain of Genesis user?</b>
                <div>
                  Gain is minimal value of user purchasing and minimal purchasing for children
                </div>
              </li>


              <li>
                <b>What is Activity in Genesis?</b>
                <div>
                  Activity in Genesis means get reward and send equal reward to parent.
                </div>
              </li>
              <li>
                <b>What is Deadline in Genesis?</b>
                <div>
                  First deadline is 30 days after Signing Up in Genesis.
                  Any activity is updating deadline. You can get reward only before deadline. Deadline - is 30 days after last Activity. After deadline you need purchase again to update deadline
                </div>
              </li>
              <li>
                <b>What is reward in Genesis?</b>
                <div>
                  There is only one rule in Genesis - you will get 50% of any funds which will come from your children, and another 50% automatically will be transferred to parent
                </div>
              </li>
            </ul>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import EtherData from "ether";

  export default {
    components: {},
    data: function () {
      return {
        contract: ''
      }
    },
    created: function () {
      this.init();
    },
    methods: {
      init() {
        this.contract = EtherData.address;
      }
    }
  }
</script>
