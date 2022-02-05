// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./DaoOnDemand.sol";

contract ParentContract {
    DaoOnDemand public newDao;

    mapping(address => DaoOnDemand[]) public addressToDao; 
    mapping(address=>address) public ownerOf;
    mapping(address=>uint256) public balanceOf;

    constructor(){}

    function createDAO(
            string memory _name, 
            string memory _symbol, 
            uint256 _totalSupply, 
            uint256 _totalAvailableForSale,
            uint256 _amountToRaise
            ) public returns(address) {
        newDao = new DaoOnDemand(msg.sender, _name, _symbol, _totalSupply, _totalAvailableForSale, _amountToRaise);
        addressToDao[msg.sender].push(newDao);
        ownerOf[address(newDao)] = msg.sender;
        return address(newDao);
    }

    function symbolFromParent(address _daoAddress) public view returns(string memory) {
        return DaoOnDemand(_daoAddress).symbol();
    }

    function nameFromParent(address _daoAddress) public view returns(string memory) {
        return DaoOnDemand(_daoAddress).name();
    }

    function balanceOfFromParent(address _owner, address _daoAddress) public view returns(uint256 balance) {
        return DaoOnDemand(_daoAddress).balanceOf(_owner);
    }

    function mintFromParent(address _daoAddress, uint _coins) public payable {
        uint256 totalMinted = DaoOnDemand(_daoAddress).totalMinted();
        uint256 totalSupply = DaoOnDemand(_daoAddress).totalSupply();
        uint256 pricePerCoin = DaoOnDemand(_daoAddress).pricePerCoin();

        require(_coins + totalMinted < totalSupply, "Not enough tokens left to mint");
        require(msg.value >= _coins * pricePerCoin, "Not paid enough");

        DaoOnDemand(_daoAddress).mint(msg.sender, _coins);
        balanceOf[_daoAddress] += msg.value;
    }

    function getContractBalanceFromParent(address _daoAddress) public view returns(uint256 balance){
        return DaoOnDemand(_daoAddress).getContractBalance();
    }

    function withdrawFromParent(address _daoAddress) public {
        require(ownerOf[_daoAddress] == msg.sender, "Only Owner can withdraw");
        payable(msg.sender).transfer(balanceOf[_daoAddress]);
    }
    
}

