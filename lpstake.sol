pragma solidity >=0.6.0;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

pragma solidity >=0.6.0;

library SafeMath {
 
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

  
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

   
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

   
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

  
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

   
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

pragma solidity >=0.6.2;

library Address {
  
    function isContract(address account) internal view returns (bool) {
        
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

 
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

 
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

  
  
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

 
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

 
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
          
            if (returndata.length > 0) {
               
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

pragma solidity >=0.6.0;

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

  
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
     
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

 
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
      
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
          
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

//usdt-etet stake contract
contract ULPStake{
    using SafeMath for uint;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    IERC20 public etetToken;
    IERC20 public UlpToken;
    
    address public owner;
    address public precipitation;
    
    uint256 public ulpStakeTotalSupply=0;



    struct UserInfo {
        uint256 amount; 
        bool  IsUpdate;
        address A;
    }

    address[]   stakers;
    
    mapping(address =>bool) public admin;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;
    mapping(address =>uint)  userRewards;
    mapping(address =>uint)  public userEachRewards;
    
    mapping(address =>uint)public userReceivedRewards;
    mapping(address =>uint) userLastRewardTime;
    uint public nowMiunteReward ;
   
    uint public reward=31412705010407710000;
    uint  public coefficient = 5;
    mapping (address => UserInfo ) public usersInfo;
    
    uint nowWeek=1 ;
     
    uint256  startTime;



    event stakeULPTransfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
    event unStakeULPTransfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
     event ReceiveAwardTransfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    constructor(IERC20 _etetToken, IERC20 _ulpToken,address _precipitation)  public  {
        etetToken = _etetToken;
        UlpToken = _ulpToken;
        owner = msg.sender;
        startTime = block.timestamp;
        nowMiunteReward=reward.div(10080);
        admin[msg.sender]=true;
        precipitation=_precipitation;
        
    }
    
    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }
     modifier onlyAdmin {
        require (admin[msg.sender]);
        _;
    }
    
    
    function setAdmin(address _admin)public onlyOwner{
        admin[_admin]=true;
    }
    function delAdmin(address _admin)public onlyOwner{
        admin[_admin]=false;
    }
    
    
    function getEtetTotalSupply()public  view returns(uint256 ){
        
        return  etetToken.balanceOf(address(this));
    }

    function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
        owner = newOwner;
      }
    }
    
    function setNewPrecipitation(address newprecipitation) onlyOwner public {
        if (newprecipitation != address(0)) {
        precipitation = newprecipitation;
      }
    }
    
    function setUserInfo(address user,address _A)public onlyAdmin{
               UserInfo storage userInfo = usersInfo[user];
                userInfo.A=_A;
               
                userInfo.IsUpdate=true;
    }
    function IsUpdateUserInfo(address userAddress)public view onlyAdmin returns(bool){
        UserInfo storage userInfo = usersInfo[userAddress];
        return userInfo.IsUpdate;
    }
    
    
    function stakeTokens(uint _amount) public {
        require(_amount > 0, "amount cannot be 0");
        
        updateWeek();
        UlpToken.transferFrom(msg.sender, address(this), _amount);
        ulpStakeTotalSupply = ulpStakeTotalSupply.add(_amount);
        
        emit stakeULPTransfer(msg.sender,address(this),_amount);
        
        uint h =block.timestamp.sub(userLastRewardTime[msg.sender]); 
        uint minute =h.div(60);
        uint balance = stakingBalance[msg.sender];
            
            
        userRewards[msg.sender]= minute.mul( nowMiunteReward).mul(balance).div(ulpStakeTotalSupply).add(userRewards[msg.sender]);
           
        userEachRewards[msg.sender]=userRewards[msg.sender].mul(8).div(10);
            if(minute > 0) {
                userLastRewardTime[msg.sender]=block.timestamp;
            }
        
        stakingBalance[msg.sender] = stakingBalance[msg.sender].add( _amount);

        
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        UserInfo storage userInfo = usersInfo[msg.sender];
        userInfo.amount=stakingBalance[msg.sender];
        
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
       
    }

    
    function unstakeTokens(uint _amount) public {
        
        updateWeek();
        
        uint balance = stakingBalance[msg.sender];

        require(balance > 0, "staking balance cannot be 0");
        require(balance>=_amount,"Unsecured amount is greater than mortgage amount!");
        
        
            uint h =block.timestamp.sub(userLastRewardTime[msg.sender]); 
            uint minute =h.div(60);
           
            if (balance>0){
                 userRewards[msg.sender]= minute.mul( nowMiunteReward).mul(balance).div(ulpStakeTotalSupply).add(userRewards[msg.sender]);
                 userEachRewards[msg.sender]=userRewards[msg.sender].mul(8).div(10);
            }
            
         
            if(minute > 0) {
                userLastRewardTime[msg.sender]=block.timestamp;
            }
        
        UlpToken.transfer(msg.sender, _amount);

        emit unStakeULPTransfer(address(this),msg.sender, _amount);
        
        ulpStakeTotalSupply = ulpStakeTotalSupply.sub(_amount);
        
        stakingBalance[msg.sender] = stakingBalance[msg.sender].sub(_amount);

        if (stakingBalance[msg.sender]<=0){
             isStaking[msg.sender] = false;
        }
       
    }

    function updateWeek()public{
    
        uint nowtime = block.timestamp.sub(startTime);
        
        if (nowtime>604800){
            nowWeek=nowWeek.add(1);
            reward=reward.add(reward.mul(coefficient).div(100));
            nowMiunteReward=reward.div(10080);
            startTime=block.timestamp;
        }
        return;
    }

  
    function calculateUserTheReward(address userAddress)public {
        
        require(ulpStakeTotalSupply>0,"no staker!");
        
            updateWeek();
        
            uint h =block.timestamp.sub(userLastRewardTime[userAddress]); 
            uint minute =h.div(60);
            uint balance = stakingBalance[userAddress];
            
            if (balance>0){
                 userRewards[userAddress]= minute.mul( nowMiunteReward).mul(balance).div(ulpStakeTotalSupply).add(userRewards[userAddress]);
                 userEachRewards[msg.sender]=userRewards[msg.sender].mul(8).div(10);
            }
            
            if(minute > 0) {
                userLastRewardTime[userAddress]=block.timestamp;
            }
        
    }
    
  

    function ReceiveAward()public{
        
        require(userRewards[msg.sender]>0,"no reward!");
        
         UserInfo storage userInfo = usersInfo[msg.sender];
        
            if (!userInfo.IsUpdate){
                userInfo.A=precipitation;
            }
            
            uint256 rewards = userRewards[msg.sender];
            
            uint256 accountRewards =rewards.mul(9).div(10);
            etetToken.transfer(msg.sender, accountRewards);
            
            uint256  ARewards = rewards.div(10);
            etetToken.transfer(userInfo.A, ARewards);
            
            emit ReceiveAwardTransfer(address(this),msg.sender, userRewards[msg.sender]);
            userReceivedRewards[msg.sender]=userReceivedRewards[msg.sender]+userRewards[msg.sender];
            userRewards[msg.sender]=0;
            userEachRewards[msg.sender]=0;
    }
    
    
  
    
    function Migration(address _to,uint _amount)public{
        
        require(msg.sender == owner, "caller must be the owner");
        
        require(_amount>=0,"number Must be positive !");
         
        uint addrBalance = etetToken.balanceOf(address(this));
        
        require(addrBalance > _amount,"This contract does not have enough balance!");
        
        etetToken.transfer(_to, _amount);
        
       
    }
    
    function getStaker(uint256 number)public view onlyAdmin returns(address){
        require(number>=0,"number Must be positive !");
        return stakers[number];
        
    }
    
    function getStakeslen()public view onlyAdmin returns(uint){
        
        return stakers.length;
        
    }
    
}