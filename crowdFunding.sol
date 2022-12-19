// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

// importing ERC20 token contract
import "./IERC20.sol";

contract CrowdFund{
    
// This are the events for  LUNCHING , CANCELLING the crowd funding campaign
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );

    event Cancel(uint id);

// This event is for the users to contribute to a particular FUND
    event Pledge(uint indexed id, address indexed caller, uint amount);
// This event is for the users to WITHDRAW to a particular FUND
    event UnPledge(uint indexed id, address indexed caller, uint amount);
// The fund creator can claim funds if the target is fulfilled
    event Claim(uint id);
// the fund owner can refund the amount pledged if target is not fulfilled
    event Refund(uint indexed id, address indexed caller , uint amount);
// This is the structure of the campaign that gets created
    struct Campaign {
        address creator;
        uint goal;
        uint pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }
// token of ERC20 is declared
    IERC20 public immutable token;
    uint public count;
    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public pledgedAmount;

// this constructor assigns the token to the ERC20 contract
    constructor(address _token){
        token = IERC20(_token);
    }

// This function shall launch the FUND
    function launch(
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    )external{
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt>= _startAt, "end at < start at");
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");

        count += 1;
        campains[count] = campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: endAt,
            claimed: false
        });

        emit Launch(count, msg.sender,_goal, _startAt , _endAt);
    }

// This function shall CANCEL the campaign by the campaign creator

    function cancel(uint _id) external{
        Campaign memory campaign = campaign[_id];
        require(msg.sender == campaign.creator , "Not creator");
        require(block.timestamp <campaign.startAt , "started");
        delete campaign[_id];
        emit Cancel(_id);
    }

// The users can pledge to the FUND 
    function pledge(uint _id, uint _amount) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "Not started");
        require(block.timestamp <= campaign.endAt , "ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id , msg.sender , _amount);
    }

// The users can withdraw their pledge
    function unpledge(uint _id, uint _amount) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);

    }

// The campaign creator can claim the funds once his goal is completed
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged<goal");
        require(!campaign.claimed, "claimed");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);

        emit Claim(_id);
    }

// this function shall refund back the contributions if the goal is not complete
    function refund(uint _id) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged<goal");

        uint bal = pledgedAmount[_id][msg.sender]; 
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id , msg.sender , _amount);
        
        }

}