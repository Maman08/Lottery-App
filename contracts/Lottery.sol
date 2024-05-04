// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Lottery{
    address payable[] public players;
    address manager;
    address payable public winner;
    constructor(){
        manager=msg.sender;
    } 
    receive() external payable { 
        require(msg.value==1 ether,"Please pay 1 ether only");
        players.push(payable(msg.sender)); 
    }
    function grtBalance() public view  returns (uint){
        require(manager==msg.sender,"Your are not the manager");
        return address(this).balance;
    }
    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.basefee,block.timestamp,players.length)));
    }
    function pickWinner()public {
        require(msg.sender==manager,"You are not the manager");
        require(players.length>=3,"Player aare less than 3");
        uint r= random();
        uint index= r%players.length;
        winner=players[index];
        winner.transfer(grtBalance());
        players= new address payable[](0); 
    }
    function allPlayers() public view returns(address payable[] memory ){
        return players;
    } 
}


