pragma solidity ^0.5.0;

contract EsToken {
    string  public name = "ES Token";
    string  public symbol = "ES";
    uint256 public totalSupply = 5000000000000000000000; // 5 thousand token
    uint8   public decimals = 18;
     address public owner;
    address[] public EsAccount;


    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
 

     modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
        
    }
    
    function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
        owner = newOwner;
      }
    }
    

    function addEsAccount(address _account) onlyOwner public  returns (bool success) {
        uint256 _value= 1000000000000000000;
        
        require(EsAccount.length<=5000,"account number is full!");
        
        require(balanceOf[msg.sender] >= _value,"balance not enouth!");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_account] += _value;
        emit Transfer(msg.sender, _account, _value);
        EsAccount.push(_account);
        return true;
        
    }
    
     function getAccountlen()public view returns(uint){
        return EsAccount.length;
    }


    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
