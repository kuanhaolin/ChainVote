// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoffeeMachine{
    uint256 public cupsAvailable;
    uint256 public CoffeePrice = 0.01 ether;
    address payable public owner;

    event CoffeePurchased(address indexed buyer, uint256 changeReturned);
    
    constructor(uint256 _init){
        cupsAvailable = _init;
        owner = payable(msg.sender);
    }

    function buyCoffee() public payable {
        require(msg.value >= CoffeePrice, "Error01");
        require(cupsAvailable > 0, "Error02");
        cupsAvailable -= 1;
        uint256 change = msg.value - CoffeePrice;
        if (change > 0){
            (bool success, ) = payable(msg.sender).call{value: change}("");
            require(success, "Error03");
        }
        emit CoffeePurchased(msg.sender, change);
    }

    function withDraw() public {
        require(msg.sender == owner, "Error04");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Error05");
    }
}