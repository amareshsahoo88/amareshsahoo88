//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract testing {
  
  struct Car{
      string model;
      uint year;
      address owner;
  }

  Car public car;
  Car[] public cararr; 
  mapping(address => Car[]) public carsByOwner;

  function examples() external {
      Car memory toyota = Car("corrola" , 1990 , msg.sender);
      Car memory lambo = Car({year: 1980 , model: "gallado" , owner : msg.sender});
      Car memory tesla;

      tesla.model = "EV";
      tesla.year = 1990;
      tesla.owner = msg.sender;

      cararr.push(toyota);
      cararr.push(lambo);
      cararr.push(tesla);

      cararr.push(Car("Ferrari" , 2020 , msg.sender));

      Car memory _car = cararr[0];
      _car.year = 1999;
     delete _car.owner;

     delete cararr[1];
  }
}