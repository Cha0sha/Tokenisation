// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//Here we can name the crypto, give a symbol, price of your crypto
//With this program you can send and receive your tokens, check balance, authorice certain limit for your transaction.
//You can also set allowance for the spender.
  
contract MyToken{
    
    string name;
    string symbols;
    uint8 decimals;
    uint256 public totalsupply;

    mapping (address => uint256) public balanceof;
    mapping (address => mapping (address =>uint256)) public allowance;

    event transfer(address indexed from, address indexed to,uint256 value,uint  timestamp);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor (string memory _name, string memory _symbols, uint8 _decimals, uint _initialsupply){
        name = _name;
        symbols = _symbols;
        decimals = _decimals;
        totalsupply = _initialsupply*10**uint(decimals);
        balanceof[msg.sender]=totalsupply;
    }

    function trancefer(address _to, uint256 _value)public returns(bool success){
        require(_to!=address(0),"invalid address");
        require(balanceof[msg.sender]>=_value,"insufficient funds");

        balanceof[msg.sender]-=_value;
        balanceof[_to]+=_value;
        emit transfer(msg.sender,_to, _value, block.timestamp);
        return true;
    }

    function approve(address _spender, uint256 _value) public  returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function transferfrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_from != address(0), "invalid address");
        require(_to != address(0), "invalid address");
        require(balanceof[msg.sender]>=_value,"insufficient funds");
        require(allowance[_from][msg.sender]>=_value,"Allowance exceeded");

        balanceof[_from]-=_value;
        balanceof[_to]+=_value;
        allowance[_from][msg.sender]-=_value;
        emit transfer(msg.sender,_to, _value, block.timestamp);
        return true;
    }
}
