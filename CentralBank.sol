//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CentralBankV2{
    //structure of the CentralBank
    //mapping
    //openwallet
    //deposit fund
    //withdraw fund

    //I create the structure of the Clients
    struct Client{
        //true if have an Open wallet, false if it is not
        bool walletOn;
        //internal balance
        uint256 balance;
    }

    //Linking the address to the Clients
    mapping(address => Client) public databaseBank;

    //function to open a new wallet
    function openWallet() public {
        //check if the wallet is already open
        require(!databaseBank[msg.sender].walletOn, "Check! You have a Wallet!");
        databaseBank[msg.sender].walletOn = true;
    }

    //function to deposit funds
    function depositFund() public payable {
        //check if the wallet it's open
        require(databaseBank[msg.sender].walletOn == true, "Create a Wallet before!");
        //check if the deposit is greater than 0
        require(msg.value > 0, "Deposit must be greater than 0");
        databaseBank[msg.sender].balance = databaseBank[msg.sender].balance + msg.value;
    }

    //function to withdraw funds
    function withdrawFund(uint256 _value) public {
        //check if wallet is open
        require(databaseBank[msg.sender].walletOn == true, "No Wallet for withdraw!");
        //check if withdraw is minor of balance
        require(_value <= databaseBank[msg.sender].balance, "No enought ETH!");
        //update balance following CEI
        databaseBank[msg.sender].balance = databaseBank[msg.sender].balance - _value;
        //transfer Funds
        payable(msg.sender).transfer (_value);
    }
}
