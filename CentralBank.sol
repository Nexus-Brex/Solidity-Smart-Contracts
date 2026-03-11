//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CentralBank{

    struct Client{
        bool walletOn;
        uint256 balance;
    }

    mapping(address => Client) public databaseBank;

    function openWallet() public{
        databaseBank[msg.sender].walletOn = true;
    }

    function depositFund(uint256 _value) public{
        require (databaseBank[msg.sender].walletOn == true, "Open a new Wallet!");
        databaseBank[msg.sender].balance = databaseBank[msg.sender].balance + _value;
            }

    function withdrawFund(uint256 _value) public{
        require (databaseBank[msg.sender].walletOn == true, "Open a new Wallet!");
        require (_value <= databaseBank[msg.sender].balance);

        databaseBank[msg.sender].balance = databaseBank[msg.sender].balance - _value;
    }
}
