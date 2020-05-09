pragma solidity ^0.6.0;

import "./IERC20.sol";
import "./SafeMath.sol";


contract TimeBoundToken is IERC20 {

using SafeMath for uint256;

mapping (address => uint256) private _balanceOf;

mapping (address => mapping (address => uint256)) private allowances;

uint private _totalSupply;
address public owner;
string public name;
string public symbol;
uint8 public decimals;

 // Three addresses have taken
address abc = 0x4b92413A5086CA5484e537Ed4D667e8E69B45a19;
address stu = 0x1f4343b21c2859B514083D7e442cd4B949f8De44;
address xyz = 0x1d6c62D70E4519050E9FBF541858176F9569CC58; 


constructor () public {
    
    name = "TimeBoundToken";
    symbol = "Epochs";
    decimals = 18;
    owner = msg.sender;
    
    _totalSupply = 1000000 * (10 ** (uint256(decimals)));
    _balanceOf[owner] = _totalSupply;
    
    emit Transfer(address(this), owner, _totalSupply);
    
    
}

  function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

   
  function balanceOf(address account) public view override returns (uint256) {
        return _balanceOf[account];
    }
    
    

   function transfer(address recipient, uint256 amount) public virtual  override returns (bool) {
       
        address sender = msg.sender;
        require(sender != address(0), "BCC1: transfer from the zero address");
        require(recipient != address(0), "BCC1: transfer to the zero address");
        require(_balanceOf[sender] > amount,"BCC1: transfer amount exceeds balance");
        
        // Timestamp to lock the transaction until May 31, 2020  at 00:00 AM
        
        if(recipient == abc || recipient == stu || recipient == xyz){
        require (now > 1590883200, "Month is not ended yet");    //1590883200 Timestamp

        }
        
        else{
        _balanceOf[sender] = _balanceOf[sender].sub(amount);
        _balanceOf[recipient] = _balanceOf[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
        return true;
        }
        
       
    }
    
    

    function allowance(address tokenOwner, address spender) public view virtual  override returns (uint256) {
        return allowances[tokenOwner][spender];
    }
    
    
    
    function approve(address spender, uint256 amount) public virtual override  returns (bool) {
        address tokenOwner = msg.sender;
        require(tokenOwner != address(0), "BCC1: approve from the zero address");
        require(spender != address(0), "BCC1: approve to the zero address");
        
        allowances[tokenOwner][spender] = amount;
        
        emit Approval(tokenOwner, spender, amount);
        return true;
    }
    
    
    
      function transferFrom(address tokenOwner, address recipient, uint256 amount) public  virtual override returns (bool) {
       
        address spender = msg.sender;
        uint256 _allowance = allowances[tokenOwner][spender];
        require(_allowance > amount, "BCC: transfer amount exceeds allowance");
        
         // timestamp to lock the transaction until May 31, 2020 12 PM
        
        if(recipient == abc || recipient == stu || recipient == xyz){
        require (now > 1590883200 , "Month is not ended yet");    //1590883200 Timestamp

        }
        
        else{
        _allowance = _allowance.sub(amount);
        _balanceOf[tokenOwner] =_balanceOf[tokenOwner].sub(amount); 
        _balanceOf[recipient] = _balanceOf[recipient].add(amount);
        
        emit Transfer(tokenOwner, recipient, amount);

        allowances[tokenOwner][spender] = _allowance;
        
        emit Approval(tokenOwner, spender, amount);
        return true; 
        }
        
    }

    
} 
