// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./DaoOnDemand.sol";

contract ParentContract {
    DaoOnDemand public newDao;
    address public DaoAddress;

    mapping(address => DaoOnDemand[]) public addressToDao; 

    constructor(){}

    function createDAO(string memory _name, string memory _symbol) public {
        newDao = new DaoOnDemand(msg.sender, _name, _symbol);
        addressToDao[msg.sender].push(newDao);
    }

    function symbolFromParent() public view returns(string memory) {
        return newDao.symbol();
    }

    function nameFromParent() public view returns(string memory) {
        return newDao.name();
    }

    function balanceOfFromParent(address _owner) public view returns(uint256 balance) {
        return newDao.balanceOf(_owner);
    }

    // function mintFromParent(address _to, uint256 _amount) public {
    //     require(_amount + totalMinted < totalSupply(), "Not enough tokens left to mint");
    //     newDao.balances[_to] += _amount;
    //     totalMinted += _amount;
    // }

    // function getDeployedDaos() public view returns(address[] memory){
    //     return addressToDao[msg.sender];
    // }

    // function getDaosLength() public view returns(uint){
    //     return addressToDao[msg.sender].length;
    // }
    
}