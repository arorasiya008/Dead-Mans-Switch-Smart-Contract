// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DeadMansSwitch{
    address public owner;
    address public recipient;
    uint256 public lastAliveBlock;

    modifier onlyOwner(){
        require(msg.sender==owner,"Access Denied");
        _;
    }

    modifier notAlive(){
        require(block.number - lastAliveBlock > 10, "Still Alive");
        _;
    }

    constructor(address _recipient){
        owner = msg.sender;
        recipient = _recipient;
        lastAliveBlock = block.number;
    }

    function stillAlive() external onlyOwner{
        lastAliveBlock=block.number;
    }

    function transferBalance() external onlyOwner notAlive{
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No balance to transfer");
        payable(recipient).transfer(contractBalance);
    }

}
