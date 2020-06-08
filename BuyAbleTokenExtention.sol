pragma solidity ^0.6.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Buyable_extension is IERC20 {

using SafeMath for uint256;
using Address for address;


mapping (address => uint256) private _balanceOf;

mapping (address => mapping (address => uint256)) private allowances;

mapping(address => uint256) time_duration;


uint private _totalSupply;
address public  owner;
string public name;
string public symbol;
uint8 public decimals;
uint256 public tokenPrice;
address public delegate;
uint256 public returnPrice;

uint public equivalentTokenPerEther;
uint public totalPrice;
event log(string);



constructor () public {
    
    name = "BuyableTokenExtension";
    symbol = "BTE";
    decimals = 18;
    owner = msg.sender;
    _totalSupply = 10000000 * (10**uint256(decimals));
    _balanceOf[owner] = _totalSupply;
    tokenPrice = 1 ether;
    equivalentTokenPerEther = 100;
    totalPrice = tokenPrice.div(equivalentTokenPerEther);
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
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");
        require(_balanceOf[sender] > amount,"transfer amount exceeds balance");
        
        _balanceOf[sender] = _balanceOf[sender].sub(amount);
        _balanceOf[recipient] = _balanceOf[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
        return true;
        
        
       
    }
    

    function allowance(address tokenOwner, address spender) public view virtual  override returns (uint256) {
        return allowances[tokenOwner][spender];
    }

    
    function approve(address spender, uint256 amount) public virtual override  returns (bool) {
        address tokenOwner = msg.sender;
        require(tokenOwner != address(0), " approve from the zero address");
        require(spender != address(0), " approve to the zero address");
        
        allowances[tokenOwner][spender] = amount;
        
        emit Approval(tokenOwner, spender, amount);
        return true;
    }
    
    
      function transferFrom(address tokenOwner, address recipient, uint256 amount) public  virtual override returns (bool) {
       
        address spender = msg.sender;
        uint256 _allowance = allowances[tokenOwner][spender];
        require(_allowance > amount, "Transfer amount exceeds allowance");
        
        _allowance = _allowance.sub(amount);
        _balanceOf[tokenOwner] =_balanceOf[tokenOwner].sub(amount); 
        _balanceOf[recipient] = _balanceOf[recipient].add(amount);
        
        emit Transfer(tokenOwner, recipient, amount);

        allowances[tokenOwner][spender] = _allowance;
        
        emit Approval(tokenOwner, spender, amount);
        return true; 
        
    }
    
    
    //Buy Token
    function Buy_Token(address _buyer) public payable{
        require(_buyer != address(0));
        require(tx.origin == _buyer);
        uint numberOfToken =  msg.value.div(totalPrice);
        require(numberOfToken > 0);
        _balanceOf[_buyer] = _balanceOf[_buyer].add(numberOfToken);
        time_duration[_buyer] = now.add(30 days);
    }
    
    
    //fallback method 0.6;
    receive() external payable{
        emit log("Receive");
        Buy_Token(msg.sender);
    }
    //fallback for anonymous Value and Data Transactions
    fallback() payable external{
        Buy_Token(msg.sender);
    }
    
    
    
    //Change the ownership 
     function changeOwner(address newOwner) public onlyOwner returns(bool){
        require(newOwner != address(0), "invalid address for ownership transfer");
        if(newOwner == owner){
            revert("the provided address is already Owner ");
        }
        
        transfer(newOwner,_balanceOf[owner]);
        owner = newOwner;
        
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner,"Only owner can execute this feature");
        _;
    }

    
    function adjustPrice(uint256 _newprice, address _owner) public {
        require(owner == _owner || delegate == _owner, "Only owner or delegate can change the price of a token");
        tokenPrice = _newprice;
    }
    

    function approve_delegate(address _delegateAddress) public onlyOwner  returns(address)  {
       delegate = _delegateAddress;
       return delegate;
    }

    
    /* function return_balance(address _account, uint256 _tokenAmount) public returns(uint, uint, uint){
        returnPrice = _tokenAmount.mul(totalPrice);
        _balanceOf[owner] = owner.balance.sub(returnPrice);
        return (_account.balance, returnPrice,  _balanceOf[owner]);
    }*/
    
    //Return token 
    function return_token(address _returnAddress, uint256 _tokenAmount) public returns(uint){
        require(time_duration[_returnAddress] >= now, "Tokens cannot be return when time is over");
        returnPrice = _tokenAmount.mul(totalPrice);
        require(owner.balance >= returnPrice,"You don't have enough funds to refund the amount");
         owner.balance.sub(returnPrice);
        _returnAddress.balance.add(returnPrice);
        payable(_returnAddress).transfer(returnPrice);
        _balanceOf[_returnAddress] = _balanceOf[_returnAddress].sub(_tokenAmount);
        _returnAddress.balance;
    }

    
}
