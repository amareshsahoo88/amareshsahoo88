// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract multiSigWallet{

    // Events to be emitted while proforming the function in the multisigwallet

    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    // transaction structure while shall be pointed to using mapping

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    // Declaration of state variable

    // array of owners 
    address[] public owners;

    // mapping of owners from address to its authorisation status as an owner
    mapping(address => bool) public isOwner;

    //this variable is to store how many approvals are required to approve a transaction
    uint public required;

    // This is the array to store the transactions which are waiting for approval
    Transaction[] public transactions;

    // This is a mapping which points from transaction number to address to approval
    mapping(uint => mapping(address => bool)) public approved;

    // onlyOwner modifier 
    modifier onlyOwner() {
        require(isOwner[msg.sender],"Not owner");
        _;
    }

    // modifier to check if the transaction exists or not

    modifier txExists(uint _txId) {
        require(_txId < transactions.length, "tx does not exist");
        _;
    }

    // modifier to check if the transaction is approved or not

    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    // modifier to check if the transaction is executed or not

    modifier notexecuted(uint _txId){
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    // this constructor is to define the owners and store them in the array
    constructor(address[] memory _owners, uint _required) {
        
        // require function to check if the owner length is greater than zero so that there are validators for approving the transaction
        require(_owners.length >0 , "owners required");
        
        // require function to see that the number of approvals required is greater than 0 and less than the number of approvers existing
        require(
            _required >0 && _required <= owners.length,
            "Invalid required numbers of owners");

        // insert the owners into the owners array through the for loop

        for (uint i ; i< _owners.length ; i++){
            address owner = _owners[i];

            // check if the adress is 0
            require(owner != address(0), "invalid owner");
            // check if the owner is the already present
            require(!isOwner[owner], "owner is not unique");

            // assigning the owner as an approver for transaction
            isOwner[owner] = true;
            
            // push the owner into the owners array
            owners.push(owner);


        }

        required = _required;

    }

    // receive payments into the contract
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // submition of transaction to the contract waiting for approval 
    function submit(address _to, uint _value, bytes calldata _data)
        external
        onlyOwner{
            transactions.push(Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false
            }));
            emit Submit(transactions.length -1);

        }

    // approval function
    function aapproved(uint _txId)
            external
            onlyOwner
            txExists(_txId)
            notApproved(_txId)
            {
                approved[_txId][msg.sender] = true;
                emit Approve(msg.sender, _txId);
            }

    // this function will help in finding how many approvals have been already received

    function _getApprovalCount(uint _txId) private view returns(uint count){
        for(uint i; i< owners.length; i++){
            if (approved[_txId][owners[i]]){
                 count += 1;
            }
        }
    }

    // This function will execute the transaction in the multisig wallet
    function execute(uint _txId) external txExists(_txId) notexecuted(_txId){
        require(_getApprovalCount(_txId) >= required, "approval< required");
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");

        emit Execute(_txId);
    }

    // this transaction shall revoke the approved transaction which was waiting for execution
    function revoke(uint _txId) 
        external 
        onlyOwner 
        txExists(_txId) 
        notexecuted(_txId){
            require(approved[_txId][msg.sender], "tx not approved");
            approved[_txId][msg.sender] = false;
            emit Revoke(msg.sender, _txId);
    }
}