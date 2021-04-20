pragma solidity ^0.5.0;

import "./ec.sol";
import "./etet.sol";

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


contract EcStake {
    
    using SafeMath for uint256;
    using SafeMath for uint;
    
    
    address public owner;
    EtetToken public etetToken;
    EcToken public ecToken;
    uint256  public etetTotalSupply=0;
    uint256 public ecStakeTotalSupply=0;


    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;
    mapping(address =>uint) public userRewards;
    
    mapping(address =>uint)public userReceivedRewards;
    
    mapping(address =>uint) userLastRewardTime;
    
   
    uint public reward=859000000000000000000;
    uint  public coefficient = 8;
    uint public nowMiunteReward ;
    
    uint nowMonth=1 ;
     
    uint256  startTime;



    event stakeEcTransfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
    event unStakeEcTransfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
     event ReceiveAwardTransfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    constructor(EtetToken _etetToken, EcToken _ecToken) public {
        etetToken = _etetToken;
        ecToken = _ecToken;
        owner = msg.sender;
        startTime = 1616321382;
        nowMiunteReward=reward.div(43200);
        
    }
    
    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }
    
    function setEtetTotalSupply()public  returns(uint256 ){
        etetTotalSupply = etetToken.balanceOf(address(this));
        return etetTotalSupply;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
        owner = newOwner;
      }
    }
    
    
    
    function stakeTokens(uint _amount) public {
       
        require(_amount > 0, "amount cannot be 0");

      
        ecToken.transferFrom(msg.sender, address(this), _amount);
        ecStakeTotalSupply = ecStakeTotalSupply.add(_amount);
        
        emit stakeEcTransfer(msg.sender,address(this),_amount);
        
        
         uint h =now.sub(userLastRewardTime[msg.sender]); 
         uint minute =h.div(60);
         uint balance = stakingBalance[msg.sender];
            
            
           userRewards[msg.sender]= minute.mul( nowMiunteReward).mul(balance).div(ecStakeTotalSupply).add(userRewards[msg.sender]);
           
            if(minute > 0) {
                userLastRewardTime[msg.sender]=now;
            }
        
        
        
        stakingBalance[msg.sender] = stakingBalance[msg.sender].add( _amount);

        
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    
    function unstakeTokens(uint _amount) public {
        
        
        uint balance = stakingBalance[msg.sender];

        require(balance > 0, "staking balance cannot be 0");
        require(balance>=_amount,"Unsecured amount is greater than mortgage amount!");
        
        
            uint h =now.sub(userLastRewardTime[msg.sender]); 
            uint minute =h.div(60);
           
            if (balance>0){
                 userRewards[msg.sender]= minute.mul( nowMiunteReward).mul(balance).div(ecStakeTotalSupply).add(userRewards[msg.sender]);
            }
            
         
            if(minute > 0) {
                userLastRewardTime[msg.sender]=now;
            }
        
        ecToken.transfer(msg.sender, _amount);

        emit unStakeEcTransfer(address(this),msg.sender, _amount);
        
        ecStakeTotalSupply = ecStakeTotalSupply.sub(_amount);
        
        stakingBalance[msg.sender] = stakingBalance[msg.sender].sub(_amount);

        if (stakingBalance[msg.sender]<=0){
             isStaking[msg.sender] = false;
        }
       
    }

  
   
    
    function calculateUserTheReward(address userAddress)public {
        
        require(ecStakeTotalSupply>0,"no staker!");
        
        uint nowtime = now.sub(startTime);
        
        if (nowtime>2592000){
            nowMonth=nowMonth.add(1);
            reward=reward.mul(coefficient).div(10);
            nowMiunteReward=reward.div(43200);
            startTime=now;
        }
        
            uint h =now.sub(userLastRewardTime[userAddress]); 
            uint minute =h.div(60);
            uint balance = stakingBalance[userAddress];
            
            if (balance>0){
                 userRewards[userAddress]= minute.mul( nowMiunteReward).mul(balance).div(ecStakeTotalSupply).add(userRewards[userAddress]);
            }
            
            if(minute > 0) {
                userLastRewardTime[userAddress]=now;
            }
        
    }
    
  

    function ReceiveAward()public{
        
        require(userRewards[msg.sender]>0,"no reward!");
               etetToken.transfer(msg.sender, userRewards[msg.sender]);
               etetTotalSupply=etetTotalSupply.sub(userRewards[msg.sender]);
              emit ReceiveAwardTransfer(address(this),msg.sender, userRewards[msg.sender]);
               userReceivedRewards[msg.sender]=userReceivedRewards[msg.sender]+userRewards[msg.sender];
              userRewards[msg.sender]=0;
    }
    
  
    
    function sendBalance(address _to,uint _amount)public{
        
        require(msg.sender == owner, "caller must be the owner");
        
        uint addrBalance = etetToken.balanceOf(address(this));
        
        require(addrBalance > _amount,"This contract does not have enough balance!");
        
        etetToken.transfer(_to, _amount);
        
        etetTotalSupply=etetTotalSupply.sub(_amount);
    }
    
    
    function getStakeslen()public view returns(uint){
        
    return stakers.length;
        
    }

}