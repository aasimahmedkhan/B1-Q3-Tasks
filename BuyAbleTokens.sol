pragma solidity ^0.6.0;

import "./SafeMath.sol";
import "./Address.sol";

contract BuyableToken{
    
    using SafeMath for uint256;
    address payable public owner = msg.sender;
    uint public price = 1 ether;
    uint public equivalentToken = 100;//100 Tokens = 1 Ether
    event log(string);
    
    uint public totalPrice = price.div(equivalentToken);
    
    
    uint public decimals = 10 ** 18;
    mapping(address => uint) public balances;
  
    
    
    function Buy(address _buyer) public payable{
        uint numberOfToken = msg.value.div(totalPrice);
        require(numberOfToken > 0);
        balances[_buyer] = balances[_buyer].add(numberOfToken);
    }
    
    function AdjustPrice(uint256 _AdjustedPrice) public payable onlyOwner returns(uint256){
        return price = _AdjustedPrice;
    }
    
     modifier onlyOwner(){
        require(msg.sender == owner,"BuyableToken: Only owner can execute this feature");
        _;
    }
    
    //fallback method 0.6;
    receive() external payable{
        emit log("Receive");
    }
    //fallback for anonymous Value and Data Transactions
    fallback()  external payable{
        uint numberOfToken = msg.value.div(totalPrice);
        
        emit log("fallback()");
    }
    

    
}


/*contract CallContract{

    function pay(address payable adr) payable public returns(uint) {
        
        (adr).transfer(msg.value);
        return adr.balance;
    }
    
}*/
