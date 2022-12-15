// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract piggyBank{
    event deposit(uint amount);
    event withdraw(uint amount);
    receive() external payable{
        emit deposit(msg.value);
    }

    address public owner = msg.sender;

    function balance() public view returns(uint){
        return address(this).balance;
    }

     function withdrawal() external {
         require(msg.sender == owner, "Not owner");
         emit withdraw(address(this).balance);
         selfdestruct(payable(msg.sender));
     }
}