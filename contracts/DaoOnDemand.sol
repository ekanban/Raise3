// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DaoOnDemand is Ownable {
    address public DEPLOYER;
    string public NAME;
    string public SYMBOL;
    uint256 public TOTAL_SUPPLY;
    uint256 public TOTAL_AVAILABLE_FOR_SALE;
    uint256 public AMOUNT_TO_RAISE;
    uint256 public TOTAL_MINTED;
    uint256 public PRICE_PER_COIN;
    
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) allowances;

    constructor(
            address _daoOwner, 
            string memory _name, 
            string memory _symbol,
            uint256 _totalSupply, 
            uint256 _totalAvailableForSale,
            uint256 _amountToRaise){

        DEPLOYER = _daoOwner;
        NAME = _name;
        SYMBOL = _symbol;
        TOTAL_SUPPLY = _totalSupply;
        TOTAL_AVAILABLE_FOR_SALE = _totalAvailableForSale;
        AMOUNT_TO_RAISE = _amountToRaise;

        // transferOwnership(DEPLOYER);
        balances[DEPLOYER] = (TOTAL_SUPPLY - TOTAL_AVAILABLE_FOR_SALE);
        TOTAL_MINTED = TOTAL_SUPPLY - TOTAL_AVAILABLE_FOR_SALE;
        PRICE_PER_COIN = AMOUNT_TO_RAISE / TOTAL_AVAILABLE_FOR_SALE;
    }
    
    
    function name() public view returns (string memory){
        return NAME;
    }
    
    function symbol() public view returns (string memory) {
        return SYMBOL;
    }

    function pricePerCoin() public view returns (uint256) {
        return PRICE_PER_COIN;
    }

    function totalMinted() public view returns (uint256) {
        return TOTAL_MINTED;
    }
    
    function decimals() public pure returns (uint8) {
        return 18;
    }
    
    function totalSupply() public view returns (uint256) {
        return TOTAL_SUPPLY;
    }

    function totalRaised() public view returns (uint256) {
        return (TOTAL_MINTED - (TOTAL_SUPPLY - TOTAL_AVAILABLE_FOR_SALE))*PRICE_PER_COIN;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];    
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] > _value, "Not enough balances");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balances[_from] > _value, "Not enough balances");
        require(allowances[_from][msg.sender] > _value, "Not enough allowance");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;

        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(balances[msg.sender] > _value, "Not enough balance");
        allowances[msg.sender][_spender] = _value;
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }

    function mint(address _to, uint256 _coins) public payable onlyOwner {
        balances[_to] += _coins;
        TOTAL_MINTED += _coins;
    }

    // Need to add a withdraw function

}
