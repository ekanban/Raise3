// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DaoOnDemand is Ownable {
    string public NAME;
    string public SYMBOL;
    
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) allowances;

    address deployer;
    uint256 totalMinted = 10000 * 1e18; // the amount that is already minted to the owner.

    constructor(address _daoOwner, string memory _name, string memory _symbol){
        deployer = _daoOwner;
        transferOwnership(deployer);
        balances[deployer] = 10000 * 1e18;

        NAME = _name;
        SYMBOL = _symbol;
    }
    
    
    function name() public view returns (string memory){
        return NAME;
    }
    
    function symbol() public view returns (string memory) {
        return SYMBOL;
    }
    
    function decimals() public pure returns (uint8) {
        return 18;
    }
    
    function totalSupply() public pure returns (uint256) {
        return 1000000 * 1e18; //1M
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];    
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

    function mint(address _to, uint256 _amount) public onlyOwner {
        require(_amount + totalMinted < totalSupply(), "Not enough tokens left to mint");
        balances[_to] += _amount;
        totalMinted += _amount;
    }

}
