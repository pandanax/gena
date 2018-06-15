module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0x23B3d7671b37Ea2A270fBeba084F1668DB3201F7", // default address to use for any transaction Truffle makes during migrations
      network_id: 4
    }
  }
};


