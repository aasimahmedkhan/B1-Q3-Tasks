pragma solidity ^0.6.0;


import "./ERC721.sol";
import "./SafeMath.sol";

contract RealEstateProperty is ERC721{
    using SafeMath for uint256;

    
    constructor() ERC721("PIAIC Town Karachi", "PTK") public { }
    

    uint public listingNumber = 0;
    uint256 public tokenIdCounter;
    mapping(uint256 => string) private _askingValues;
     mapping(uint256 => string) private _offerValues;
     mapping(uint256 => string) private _acceptedOffers;
     mapping(uint256 => string) private _rejectedOffers;
    
    /** starting point **/

    function registerProperty(address _owner, string memory _tokenURI, string memory _askingValue) public returns (bool) {
        tokenIdCounter = tokenIdCounter.add(1);
        _askingValues[tokenIdCounter] = _askingValue;
        _mint(_owner,tokenIdCounter);
        _setTokenURI(tokenIdCounter, _tokenURI);
        return(true);
    }
    
    
    // list the property for sale
    function listProperty(uint256 _tokenId) public returns(bool){
        require(_exists(_tokenId), "Token ID doesn't exist");
        uint tokenID = _tokenId;
        listingNumber++;
        listedProperties[tokenID] = listingNumber;
        return true;
    }
    
    // show listed properties
    function showListedProperties(uint _tokenID) public view returns(uint, string memory, string memory) {
        uint listedNumber = listedProperties[_tokenID];
        string memory URI = _tokenURIs[_tokenID];
        string memory askedValue = _askingValues[_tokenID];
        return (listedNumber, URI, askedValue);
    }
    
    // Send buy request to the owner
    function propertyBuyRequest(uint256 _tokenID, string memory _offerValue) public returns(string memory){
        require(_tokenID >= 0);
        require(_exists(_tokenID), "Token ID doesn't exist");
        _offerValues[_tokenID] = _offerValue;
        return "Offer sent!";
        
    }
    
    
    // show the accepted offer
    function acceptedOffers(uint256 _tokenID) public view returns(string memory){
        require(_exists(_tokenID), "Token ID doesn't exist");   
        string memory acceptedOffer =  _acceptedOffers[_tokenID];
        return acceptedOffer;

    }
    
       // show the rejected offer
    function rejectOffers(uint256 _tokenID) public view returns(string memory){
        require(_exists(_tokenID), "Token ID doesn't exist");   
       string memory rejectedOffers =  _rejectedOffers[_tokenID];
        return rejectedOffers;
    }
    
    
    //accept the offer
    function accept(string memory _acceptedOffer ,uint256 _tokenID) public returns(bool){
        _acceptedOffers[_tokenID] = _acceptedOffer;
        return true;
    }
    
    //reject the offer
    function reject(string memory _RejectedOffers ,uint256 _tokenID) public returns(bool){
        _rejectedOffers[_tokenID] = _RejectedOffers;
        return true;
    }
    
    // Buy the property
     function buyProperty(address _buyerAddress, uint _tokenID) payable public returns(bool){
     
        require(_buyerAddress.balance >= msg.value, "You don't have enough funds to buy this property");
        address tokenOwner = _tokenOwners[_tokenID];
        _buyerAddress.balance.sub(msg.value);
        tokenOwner.balance.add(msg.value);
        payable(_buyerAddress).transfer(msg.value);
    
    // transfer token ownership   
        address from = tokenOwner;
        address to = _buyerAddress;
        _transfer(from, to, _tokenID);
        return true;
    }
    
}
