pragma solidity ^0.4.4;

// This is a simple contract that keeps track of balances and accepts deposits of Ether.
// 1. Does deposit() function work as expected?
// 2. Implement the missing withdraw() function that will allow only withdraw
//    of Ether after 14 days from the first deposit.

contract Test01 {
    mapping (address => uint) balances;
    mapping (address => uint) depositDates;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function deposit() public payable {
        uint amount = msg.value;
        
        require(amount > 0);
        
        balances[msg.sender] += amount;
        
        uint depositeDate = depositDates[msg.sender];
        if(depositeDate == 0) {
            depositDates[msg.sender] = now;    
        }
        
        Transfer(msg.sender, this, amount);
    }
    
    function withdraw() public returns (bool) {
        uint amount = balances[msg.sender];
        uint depositeDate = depositDates[msg.sender];
        if (amount > 0 && now - depositeDate > 14 days) {
            balances[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                balances[msg.sender] = amount;
                return false;
            }
            Transfer(this, msg.sender, amount);
        }
        return true;
    }
    
    function getBalance() public view
            returns (uint b) {
        b = balances[msg.sender];
    }
    
    function getFirstDepositeDate() public view
            returns (uint b) {
        b = depositDates[msg.sender];
    }
}
