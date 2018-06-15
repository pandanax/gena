pragma solidity ^0.4.0;


contract Genesis {

  event Signup(address addr, address parent);

  event Raise(address addr, uint amount);

  event Payment(address addr, uint amount);

  event Kill(address addr);

  mapping (address => address[]) public children;

  mapping (address => address) public parents;

  mapping (address => uint) public funds;

  mapping (address => string) public nicknames;

  mapping (address => uint) public lastActivity;

  mapping (address => uint) public payments;

  uint public customers;

  uint public capital;

  uint public constant deadLine = 30 days;

  address public genesis; //first element in genesis net

  modifier onlyGenesisOrAdmin() {
    require(msg.sender == genesis || parents[msg.sender] == genesis);
    _;
  }
  modifier onlyAdmin() {
    require(parents[msg.sender] == genesis);
    _;
  }
  modifier onlyGenesis() {
    require(msg.sender == genesis);
    _;
  }

  modifier withFunds() {
    //funds for me?
    require(funds[msg.sender] > 0);
    _;
  }


  function isNotRegistered(address addr) constant public returns (bool){
    if (parents[addr] == 0x0 && children[addr].length == 0) {return true;}
    return false;
  }


  function registerAdmin(address admin, string name, uint enter) onlyGenesis public {
    require(isNotRegistered(admin));
    nicknames[admin] = name;
    parents[admin] = msg.sender;
    payments[admin] = enter;
    children[genesis].push(admin);
    customers++;
    lastActivity[genesis] = now;
    lastActivity[admin] = now;
  }

  function bytesToAddress(bytes b) pure public returns (address) {
    uint result = 0;
    for (uint i = b.length - 1; i + 1 > 0; i--) {
      uint c = uint(b[i]);
      uint to_inc = c * (16 ** ((b.length - i - 1) * 2));
      result += to_inc;
    }
    return address(result);
  }

  function() payable public {

    if (isNotRegistered(msg.sender)) {
      registration(bytesToAddress(msg.data), "");
    }
    else {
      updateActivity();
    }
  }

  function setNickname(string nickname) public {
    nicknames[msg.sender] = nickname;
  }

  function updateActivity() payable public {
    //is registered
    require(!isNotRegistered(msg.sender));
    require(msg.value >= payments[msg.sender]);

    //increase funds for parent
    funds[parents[msg.sender]] += msg.value;

    capital += msg.value;
    lastActivity[msg.sender] = now;
    emit Payment(msg.sender, msg.value);

  }
  //user registration
  function registration(address parent, string nickname) payable public {

    //payment is greater
    require(msg.value >= payments[parent]);

    //child is not registered
    require(isNotRegistered(msg.sender));

    //parent is registered
    require(!isNotRegistered(parent));

    //set nick
    nicknames[msg.sender] = nickname;

    //set parent for user
    parents[msg.sender] = parent;

    //push new child for parent
    children[parent].push(msg.sender);

    //increase funds for parent
    funds[parent] += msg.value;


    capital += msg.value;
    customers++;

    payments[msg.sender] = msg.value;

    //first child activity
    lastActivity[msg.sender] = now;

    //events
    emit Signup(msg.sender, parent);
    emit Payment(msg.sender, msg.value);

  }


  //every user
  function getMine() public withFunds {

    //is active
    require(now <= lastActivity[msg.sender] + deadLine);
    //is not registered
    require(!isNotRegistered(msg.sender));
    //is not genesis
    require(msg.sender != genesis);

    uint mine = myAvailableFunds();

    funds[parents[msg.sender]] += funds[msg.sender] - mine;

    funds[msg.sender] = 0;

    msg.sender.transfer(mine);

    emit Raise(msg.sender, mine);

    lastActivity[msg.sender] = now;

  }

  function getMineAdmin() public onlyAdmin withFunds {

    uint mine = myAvailableFunds();

    funds[parents[msg.sender]] += funds[msg.sender] - mine;

    msg.sender.transfer(mine);
    funds[msg.sender] = 0;
    lastActivity[msg.sender] = now;

    emit Raise(msg.sender, mine);
  }

  function getMineGenesis() public onlyGenesis withFunds {

    //for me
    uint mine = funds[msg.sender];

    msg.sender.transfer(mine);
    funds[msg.sender] = 0;
    lastActivity[msg.sender] = now;

    emit Raise(msg.sender, mine);

  }

  function myAvailableFunds() public constant returns (uint myFunds) {
    return availableFundsOf(msg.sender);
  }

  function availableFundsOf(address addr) public constant returns (uint availableFunds) {
    return funds[addr] / 2;
  }

  function removeChild(uint index, address child) private {

    if (index >= children[parents[child]].length) return;

    for (uint i = index; i < children[parents[child]].length - 1; i++) {
      children[parents[child]][i] = children[parents[child]][i + 1];
    }
    delete children[parents[child]][children[parents[child]].length - 1];
    children[parents[child]].length--;

  }


  function killByDeadline(address child) public onlyGenesisOrAdmin {

    require(child != genesis);

    require(now > lastActivity[child] + deadLine);


    //move children to parent of given child
    for (uint i = 0; i < children[child].length; i++) {

      children[parents[child]].push(children[child][i]);
      parents[children[child][i]] = parents[child];
      children[child][i] = 0x0;
    }

    //remove given child from children of parent of given child
    for (uint j = 0; j < children[parents[child]].length; j++) {

      if (children[parents[child]][j] == child) {
        removeChild(j, child);
        break;
      }
    }


    children[child].length = 0;

    funds[msg.sender] += funds[child];

    funds[child] = 0;

    nicknames[child] = '';

    lastActivity[child] = 0;

    payments[msg.sender] = 0;

    lastActivity[msg.sender] = now;

    parents[child] = 0x0;

    customers--;

    emit Kill(child);

  }


  function transferUser(address newAddress) public {


    require(isNotRegistered(newAddress));
    require(!isNotRegistered(msg.sender));



    //move children
    for (uint i = 0; i < children[msg.sender].length; i++) {

      children[newAddress].push(children[msg.sender][i]);
      parents[children[msg.sender][i]] = newAddress;
      children[msg.sender][i] = 0x0;

    }

    //if !genesis
    if (msg.sender != genesis) {

      //add to children of parent
      children[parents[msg.sender]].push(newAddress);

      //remove old addr from parent children
      for (uint j = 0; j < children[parents[msg.sender]].length; j++) {

        if (children[parents[msg.sender]][j] == msg.sender) {
          removeChild(j, msg.sender);
          break;
        }
      }

    } else {
      genesis = newAddress;
    }



    children[msg.sender].length = 0;

    funds[newAddress] = funds[msg.sender];
    funds[msg.sender] = 0;

    parents[newAddress] = parents[msg.sender];
    parents[msg.sender] = 0x0;

    payments[newAddress] = payments[msg.sender];
    payments[msg.sender] = 0;

    nicknames[newAddress] = nicknames[msg.sender];
    nicknames[msg.sender] = '';

    lastActivity[newAddress] = lastActivity[msg.sender];
    lastActivity[msg.sender] = 0;

  }


  function pushFundsInsteadChild(address child) public {

    require(!isNotRegistered(child));
    require(now <= lastActivity[msg.sender] + deadLine || parents[msg.sender] == genesis || msg.sender == genesis);
    require(parents[child] == msg.sender || parents[parents[child]] == msg.sender || parents[parents[parents[child]]] == msg.sender || parents[msg.sender] == genesis || msg.sender == genesis);
    require(availableFundsOf(child) > 0);

    uint reward = availableFundsOf(child);

    funds[parents[child]] += funds[child] - reward;

    funds[child] = 0;

    child.transfer(reward);

    emit Raise(child, reward);

    lastActivity[msg.sender] = now;

  }

//create first element
constructor (address firstChild, uint initialEnter) public {

require(msg.sender != firstChild);
genesis = msg.sender;
nicknames[genesis] = 'Genesis';
parents[genesis] = 0x0;
payments[genesis] = 0;
customers++;
registerAdmin(firstChild, 'Admin', initialEnter);

}


}


//"0xBA0b064815127142E114cAB52967b7A2F8EDE724","10000000000000000"


