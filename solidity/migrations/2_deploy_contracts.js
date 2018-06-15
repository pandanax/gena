var Lotery = artifacts.require("./Lotery.sol");
var Hash = artifacts.require("./Hash.sol");

module.exports = function (deployer) {


    //uint _duration, uint _ticketPrice, uint _benefitPercents, uint _maxTicketAmount


    return deployer.deploy(Hash).then(function () {




        var _duration = 60 * 60; //1 hour in sec
        var _ticketPrice = 0.01 * Math.pow(10, 18);
        var _benefitPercents = 5;
        var _maxTicketAmount = 100;

        return deployer.deploy(Lotery, _duration, _ticketPrice, _benefitPercents, _maxTicketAmount, Hash.address).then(function () {



            var _duration = 3 * 60 * 60; //3 hour in sec
            var _ticketPrice = 0.03 * Math.pow(10, 18);
            var _benefitPercents = 5;
            var _maxTicketAmount = 33;

            return deployer.deploy(Lotery, _duration, _ticketPrice, _benefitPercents, _maxTicketAmount, Hash.address).then(function () {



                var _duration = 12 * 60 * 60; //12 hour in sec
                var _ticketPrice = 0.1 * Math.pow(10, 18);
                var _benefitPercents = 5;
                var _maxTicketAmount = 10;

                return deployer.deploy(Lotery, _duration, _ticketPrice, _benefitPercents, _maxTicketAmount, Hash.address).then(function () {




                    var _duration = 24 * 60 * 60; //12 hour in sec
                    var _ticketPrice = 0.5 * Math.pow(10, 18);
                    var _benefitPercents = 3;
                    var _maxTicketAmount = 10;

                    return deployer.deploy(Lotery, _duration, _ticketPrice, _benefitPercents, _maxTicketAmount, Hash.address).then(function () {});


                });

            });


        });

    });

};

//geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --rpccorsdomain "http://localhost:8545,http://localhost:4000,http://localhost:8080"
//geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0x117f36242f83d54502a714653dffbbaa1e1fcf07" --rpccorsdomain "http://localhost:8545,http://localhost:3000, http://localhost:4000, http://localhost:8080"

/*
*
*   Deploying Hash...
 ... 0x09e5f16784d069e770e6a3b015111698f36bc1e644a8a77270cd91ccf535ba4f
 Hash: 0x4777539da86cb1b2cb8d2cb150ee61eb8b2d23fd
 Deploying Lotery...
 ... 0xd0e3e522e2338a59f245a83152a53555d9e88afccc489a55714baa827dc6cfc5
 Lotery: 0xcea5de763db47571c0b17f63da0c2b3bf678b9dd
 Replacing Lotery...
 ... 0xe2f448c7bd12cb2f98c90706f1aef7da64d13ca536840eb6e1d1d0f07de2ad60
 Lotery: 0xecd5f600fae1f202b60a04b52213225d0671253c
 Replacing Lotery...
 ... 0x0ef0a93ad7bbd318fa99fdf2ad825523bc0643f427d68b54a5bd193075cf5072
 Lotery: 0x103da18857d02861b008e56b0513d08b8752af6d
 Replacing Lotery...
 ... 0xba06786d462915255ac81aef5f03afc7e91464917172e6e9972c15492ecd761a
 Lotery: 0x82496f48e2e9695a74faca191566b0eb2611ffb1
 Saving successful migration to network...
 ... 0xbf4a86c13d9c31ed743045c42c12a655ede25e1a2337a179a9321740d5894487
 Saving artifacts...

 *
* */