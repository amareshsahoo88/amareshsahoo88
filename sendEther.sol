//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract sendEther {
    constructor() payable {

    }

    receive() external payable{}

    function sendViaTransfer(address payable _to) external payable{
        _to.transfer(123);
    }

    function sendViaSend(address payable _to) external payable{
        bool sent = _to.send(123);
        require(sent,"sending Failed");

    }

    function sendViaCall(address payable _to) external payable{
        (bool success, ) = _to.call{value: 123}("");
        require(success, "Call failed");

    }
}

contract EthReceiver{
    event Log(uint amount , uint gas);

    receive() external payable{
        emit Log(msg.value, gasleft());
    }
}