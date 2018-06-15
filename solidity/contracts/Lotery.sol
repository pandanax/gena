pragma solidity ^0.4.0;




import './Lib.sol';
import './Hash.sol';



contract Lotery is Ownable {

    //event when gamer is buying a new ticket
    event TicketSelling(uint periodNumber, address indexed from, bytes32 hash, uint when);

    //event when period finished
    event PeriodFinished(uint periodNumber, address indexed winnerAddr, uint reward, bytes32 winnerHash, uint when);

    //event when any funds transferred
    event TransferBenefit(address indexed to, uint value);

    //current period of the game
    uint public currentPeriod;

    //if maxTicketAmount is not rised and maxPeriodDuration from period start is gone everyone can finish current round
    uint public maxPeriodDuration;

    uint public maxTicketAmount;

    //ticket price in this contract
    uint public ticketPrice;

    //part for owner
    uint public benefitPercents;

    //funds for owner
    uint public benefitFunds;

    //base game hash from other contract Hash
    bytes32 private baseHash;

    Hash private hashGenerator;

    //period struct
    struct period {
    uint number;
    uint startDate;
    bytes32 winnerHash;
    address winnerAddress;
    uint raised;
    uint ticketAmount;
    bool finished;
    uint reward;
    }

    //ticket struct
    struct ticket {
    uint number;
    address addr;
    bytes32 hash;
    }


    //ticket store
    mapping (uint => mapping (uint => ticket)) public tickets;

    //periods store
    mapping (uint => period) public periods;


    function Lotery(uint _maxPeriodDuration, uint _ticketPrice, uint _benefitPercents, uint _maxTicketAmount, address _hashAddr) public {

        //set data in constructor
        maxPeriodDuration = _maxPeriodDuration;
        ticketPrice = _ticketPrice;
        benefitPercents = _benefitPercents;
        maxTicketAmount = _maxTicketAmount;

        //get initial hash
        hashGenerator = Hash(_hashAddr);
        baseHash = hashGenerator.get();

        //start initial period
        periods[currentPeriod].number = currentPeriod;
        periods[currentPeriod].startDate = now;

    }



    //start new period
    function startNewPeriod() private {
        //if prev period finished
        require(periods[currentPeriod].finished);
        //init new period
        currentPeriod++;
        periods[currentPeriod].number = currentPeriod;
        periods[currentPeriod].startDate = now;

    }





    //buy ticket with specified round and passing string data
    function buyTicket(uint periodNumber, string data) payable public {

        //only with ticket price!
        require(msg.value == ticketPrice);
        //only if current ticketAmount < maxTicketAmount
        require(periods[periodNumber].ticketAmount < maxTicketAmount);
        //roundNumber is currentRound
        require(periodNumber == currentPeriod);

        processTicketBuying(data, msg.value, msg.sender);

    }


    //buy ticket with msg.data and currentRound when transaction happened
    function() payable public {

        //only with ticket price!
        require(msg.value == ticketPrice);
        //only if current ticketAmount < maxTicketAmount
        require(periods[currentPeriod].ticketAmount < maxTicketAmount);




        processTicketBuying(string(msg.data), msg.value, msg.sender);


    }

    function processTicketBuying(string data, uint value, address sender) private {


        //MAIN SECRET!
        //calc ticket hash from baseHash and user data
        //nobody knows baseHash
        bytes32 hash = sha256(data, baseHash);

        //update base hash for next tickets
        baseHash = sha256(hash, baseHash);

        //set winner if this is a best hash in round
        if (periods[currentPeriod].ticketAmount == 0 || (hash < periods[currentPeriod].winnerHash)) {
            periods[currentPeriod].winnerHash = hash;
            periods[currentPeriod].winnerAddress = sender;
        }

        //update tickets store
        tickets[currentPeriod][periods[currentPeriod].ticketAmount].number = periods[currentPeriod].ticketAmount;
        tickets[currentPeriod][periods[currentPeriod].ticketAmount].addr = sender;
        tickets[currentPeriod][periods[currentPeriod].ticketAmount].hash = hash;


        //update periods store
        periods[currentPeriod].ticketAmount++;
        periods[currentPeriod].raised += value;

        //call events
        TicketSelling(currentPeriod, sender, hash, now);

        //automatically finish and start new round if max ticket amount is raised
        if (periods[currentPeriod].ticketAmount >= maxTicketAmount) {
            finishRound();
        }

    }


    //finish round
    function finishRound() private {

        //only if not finished yet
        require(!periods[currentPeriod].finished);
        //only if ticketAmount >= maxTicketAmount
        require(periods[currentPeriod].ticketAmount >= maxTicketAmount);


        //calc reward for current winner with minus %
        uint winnerReward = periods[currentPeriod].raised - ((periods[currentPeriod].raised * benefitPercents) / 100);

        //calc owner benefit
        benefitFunds += periods[currentPeriod].raised - winnerReward;

        //calc expected balance
        uint plannedBalance = this.balance - winnerReward;

        //send ether to winner
        periods[currentPeriod].winnerAddress.transfer(winnerReward);


        //update period data
        periods[currentPeriod].reward = winnerReward;
        periods[currentPeriod].finished = true;


        //call events
        PeriodFinished(currentPeriod, periods[currentPeriod].winnerAddress, winnerReward, periods[currentPeriod].winnerHash, now);

        //automatically start new period
        startNewPeriod();

        //check balance
        assert(this.balance == plannedBalance);
    }

    //benefit for owner
    function benefit() public onlyOwner {
        require(benefitFunds > 0);

        uint plannedBalance = this.balance - benefitFunds;
        owner.transfer(benefitFunds);
        benefitFunds = 0;

        TransferBenefit(owner, benefitFunds);
        assert(this.balance == plannedBalance);
    }

    //manually finish and restart round
    function finishRoundAndStartNew() public {
        //only if round has tickets
        require(periods[currentPeriod].ticketAmount > 0);
        //only if date is expired
        require(periods[currentPeriod].startDate + maxPeriodDuration < now);
        //restart round
        finishRound();
    }


}