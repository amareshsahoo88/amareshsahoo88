// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Q1
contract Cube{

    uint public num;

    function cube(uint _num) public pure returns(uint){
        uint cub = _num*_num*_num ; 
        return cub;
    }

}

// Q2

contract oddEven{

    uint num;

    function oe(uint _num) public pure returns(uint){
        uint div = _num%2;
        if (div==0){
            return 1;
        }
        else return 0;
    }
}

// Q3

contract Avg{
    
    function avg(uint _a , uint _b , uint _c) public pure returns(uint){
        uint av = (_a + _b + _c)/3 ;
        return av;
    }

}

// Q4

contract Swap{

    uint public a;
    uint public b;

    function swap(uint _a,uint _b) public returns(uint ,uint){
        uint sw = _a;
         a = _b;
         b = sw;
        return (a , b);
    }
}

// Q5

contract power{

    function pow(uint _x, uint _y) public pure returns(uint){
        uint  _p =1;
        for(uint i =1 ; i<= _y ; i++){
           
           _p = _p * _x;
        }
        return _p;
    }
}

// Q6

contract swap{
    uint public a ;
    uint public b ;

function set(uint _a , uint _b) public {
    a = _a;
    b = _b;
}
}

// Q7

contract primenum{

    function pri(uint _num) public pure returns(uint){
        uint res;
        uint count;
        if(_num==1){
            return 1;
        }
        else{
        for(uint i =1; i<= _num ; i++){
            res = _num % i;
                if(res==0){
                    count++;
                }
        }
        if(count==2){
            return 1;
        }
        else return 0;
    }
    }
}

// Q8

contract armstrnum{
    uint public num; 

    uint [] public numArr;

    uint rem ;
    
    function get(uint _num) public {
        num = _num;
    }

    function createArr() public {
        do{
            rem = num % 10;
            numArr.push(rem);
            num =num/10;
        } while(rem<10);

    }


}

// Q9

