npm install
npm run dev
npm run build

geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --rpccorsdomain "http://localhost:8545,http://localhost:3000,http://10.0.2.2:4000,http://localhost:4000,http://localhost:8080" --unlock="0x23B3d7671b37Ea2A270fBeba084F1668DB3201F7" --datadir /Users/pandanax/eth1
truffle migrate --network rinkeby
