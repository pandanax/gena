pragma solidity ^0.4.0;


contract Hash {

  uint private a = 777111666111777;

  string private b = 'CrYppT0GaIIIeV0o0-';

  bytes32 private base = sha256(keccak256(a, b), now);

  function get() public constant returns (bytes32 hash) {
    base = sha256(base, a, b);
    return base;
  }

}

//РЕАЛЬНЫЙ АДРЕС

//0xe272c721ba6f1892f0ecb57481ecc6d2b9673446

/*[
{
"constant": true,
"inputs": [],
"name": "get",
"outputs": [
{
"name": "hash",
"type": "bytes32"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
}
]*/
