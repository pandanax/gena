<template>
  <div id="app" class="container-fluid">

    <div v-if="currentNode">
      <div>

        {{currentNode.data.nickname}}
      </div>

      <div>

        {{currentNode.data.address}}
      </div>

      <div>

      Gain:  {{currentNode.data.gain | eth}}
      </div>
      <div v-if="currentNode.data.deadline">

        DEADLINE!
      </div>
      <div>
        Last Activity {{currentNode.data.lastActivity | sdate}} {{currentNode.data.lastActivity | stime}}
      </div>
      <div>

        Ready for reward {{currentNode.data.funds | eth}}
      </div>
    </div>

    <div class=" panel panel-default" v-if="loaded">
      <tree ref="tree" :identifier="getId" :zoomable="zoomable" :data="Graph.tree" :node-text="nodeText"
            :margin-x="Marginx" :margin-y="Marginy" :radius="radius" :type="type" :layout-type="layoutType"
            :duration="duration" class="tree" @clicked="onClick" @expand="onExpand" @retract="onRetract"/>
    </div>

  </div>
</template>

<script>
  import {tree} from 'vued3tree'
  import Metamask from 'services/Metamask';

  const MetamaskService = new Metamask();

  export default {

    data: function () {
      return {
        loaded: false,
        type: 'tree',
        layoutType: 'euclidean',
        duration: 750,
        Marginx: 30,
        Marginy: 30,
        radius: 5,
        nodeText: 'text',
        currentNode: null,
        zoomable: true,
        isLoading: false,
        events: [],
        showCard: false,
        genesis: '',
        Graph: {

          tree: {
            children: [],
            id: 0,
            text: "genesis"
          },
          links: [],
          text: "genesis"
        }


      }


    },
    components: {
      tree
    },
    created: function () {
      this.init();
    },
    methods: {
      do (action) {
        if (this.currentNode) {
          this.isLoading = true
          this.$refs['tree'][action](this.currentNode).then(() => {
            this.isLoading = false
          })
        }
      },


      init: function () {
        let self = this;
        self.level = MetamaskService.detectLevel();
        self.address = MetamaskService.genesis().getAccount();
        let id = 1;
        let calling = 0;

        function subAddr(r) {
          return r.substr(0, 4) + '..' + r.substr(r.length - 2, 2)
        }


        function readChildren(addr, index, node) {

          calling++;
          node.text = subAddr(addr);
          node.id = id++;
          node.address = addr;

          if (!node.children) {
            node.children = []
          }
          calling++;

          MetamaskService.genesis().getField('availableFundsOf', [addr]).then(function (funds) {

            MetamaskService.genesis().getField('payments', [addr]).then(function (gain) {

              node.gain = gain
              MetamaskService.genesis().getField('lastActivity', [addr]).then(function (lastActivity) {

                node.lastActivity = lastActivity

                MetamaskService.genesis().getField('deadLine').then(function (deadline) {


                  MetamaskService.genesis().getField('nicknames', [addr]).then(function (r) {
                    if (r) {
                      node.nickname = r
                      node.text = r
                    }

                    node.funds = funds
                    if (funds > 0) {

                      node.text += " [" + funds / Math.pow(10, 18) + " ETH]"//(", " + !isNaN(r) ? r / Math.pow(10, 18) : "0" + " ETH");
                    }

                    if (addr != self.genesis && (lastActivity * 1 + deadline * 1) * 1000 < (new Date()).getTime()) {
                      node.deadline = true
                      node.text += ' DEADLINE'
                    }


                    calling--;
                    if (!calling) {

                      self.loaded = true
                    }
                  })
                })
              })
            })
          })

          MetamaskService.genesis().getField('children', [addr, index]).then(function (r) {
            if (r != '0x') {
              let el = {
                id: id++,
                text: subAddr(r),
                address: r,
                children: []
              }
              node.children.push(el)

              readChildren(r, 0, el)
              readChildren(addr, ++index, node);
            }


            calling--;
            if (!calling) {

              self.loaded = true
            }
          })

        }


        MetamaskService.genesis().getField('genesis').then(function (g) {

          self.genesis = g

          readChildren(g, 0, self.Graph.tree);


        });


      },


      getId(node)
      {
        return node.id
      }
      ,
      expandAll()
      {
        this.do('expandAll')
      }
      ,
      collapseAll()
      {
        this.do('collapseAll')
      }
      ,
      showOnly()
      {
        this.do('showOnly')
      }
      ,
      show()
      {
        this.do('show')
      }
      ,
      onClick(evt)
      {

        this.currentNode = evt.element

      }
      ,
      onExpand(evt)
      {
        this.onEvent('onExpand', evt)
      }
      ,
      onRetract(evt)
      {
        this.onEvent('onRetract', evt)
      }
      ,
      onEvent(eventName, data)
      {
        this.events.push({eventName, data: data.data})
        console.log({eventName, data: data})
      }
      ,
      resetZoom()
      {
        this.isLoading = true
        this.$refs['tree'].resetZoom().then(() => {
          this.isLoading = false
        })
      }
    }
  }
</script>

<style>
  /*#app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 20px;
  }*/

  .tree {
    height: 600px;
    width: 100%;
  }

  .graph-root {
    height: 800px;
    width: 100%;
  }

  .log {
    height: 500px;
    overflow-x: auto;
    overflow-y: auto;
    overflow: auto;
    text-align: left;
  }

</style>
