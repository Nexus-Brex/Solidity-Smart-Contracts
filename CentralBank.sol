//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//import the aggregatorV3Interface about usd value
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract CentralBankV3 {

    //new rules, minumum deposit = 50 USD
    uint256 public minimumUsd = 50 * 1e18;
    
    //structure of the Client
    struct Client {
        //true if the wallet is open, false if it isn't
        bool walletOn;
        //balance of the wallet
        uint256 balance;
    }

    //link the Address to the Client
    mapping(address => Client) public databaseBank;

    //function to open a new wallet
    function openWallet() public {
        //check if the wallet is already open
        require(!databaseBank[msg.sender].walletOn, "Ehi! You Have a Wallet!");
        databaseBank[msg.sender].walletOn = true;
    }

    //Oracle section

    //function to ask the 1eth price
    function getPrice() public view returns (uint256) {
        //address of Chainlink contract on Sepolia Testnet
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        //get the information
        (, int256 price, , , ) = priceFeed.latestRoundData();
        //return the price
        return uint256(price) * 1e10;
    }

    //convert the wei in USD
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        //the ETH price 
        uint256 ethPrice = getPrice();
        //the conversion
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        //value in USD
        return ethAmountInUsd;
    }

    //function of deposit
    function depositFund() public payable{
        //check if the wallet is open
        require(databaseBank[msg.sender].walletOn == true, "Open a new Wallet!");
        //check if the amount it is greater than 50 USD
        require(getConversionRate(msg.value) >= minimumUsd, "Your deposit must be minimum 50USD");
        //update the balance
        databaseBank[msg.sender].balance = databaseBank[msg.sender].balance + msg.value;
    }

    //function for withdraw
    function withdrawFund(uint256 _value) public {
        //check if the wallet is open
        require(databaseBank[msg.sender].walletOn == true, "Open a Wallet and deposit funds!");
        //check if the balance is greater than the amount to be withdraw
        require(databaseBank[msg.sender].balance >= _value, "No enought funds!");
        //update the balance
        databaseBank[msg.sender].balance = databaseBank[msg.sender].balance - _value;
        //send the amount to the Client by .call
        (bool success, ) = payable(msg.sender).call{value: _value}("");
        require(success, "Error: transaction failed!");
    }


}
