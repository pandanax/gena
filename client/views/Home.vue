<template>
  <div class="body">

        <main-genesis-info></main-genesis-info>

  </div>
</template>

<script>
  import MainGenesisInfo from 'components/MainGenesisInfo'
  import DownloadMetamask from 'components/DownloadMetamask'

  export default {
    components: {
      DownloadMetamask,
      MainGenesisInfo
    }
  }
</script>
