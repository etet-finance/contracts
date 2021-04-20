pragma solidity ^0.5.0;

contract EcToken {
    string  public name = "EC Token";
    string  public symbol = "EC";
    uint256 public totalSupply = 0; 
    uint8   public decimals = 18;
    address public owner;

 modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }
    
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

    event Burn(address indexed from, uint256 value);
    
    
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
         owner = msg.sender;
    }


 function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
        owner = newOwner;
      }
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
 
      function mintToken(address target, uint256 mintedAmount) public onlyOwner returns (bool success){
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
       emit Transfer(address(0), address(this), mintedAmount);
       emit Transfer(address(this), target, mintedAmount);
        return true;
    }

}