//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//import Oracle library
import {PriceConverter} from "./PriceConverter.sol";
//import AggregatorV3Interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract CentralBankV4 {
    //using the library for all numbers
    using PriceConverter for uint256;
    //state variables

    //deposit minimum = 50USD
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    //Yield 5% in dividends
    uint256 public constant REWARD_PERCENTAGE = 5;
    //Owner address
    address public immutable i_owner;
    //Chainlink interface
    AggregatorV3Interface public priceFeed;
    
    //structure of the Clients
    struct Client {
        //the wallet it's open?
        bool walletOn;
        //balance of the client;
        uint256 balance;
        //rewards from staking
        uint256 stakingReward;
    }

    //mapping
    mapping(address => Client) public databaseBank;
    //Array
    address[] public arrayClients;

    //constructor ,work just at Deploy
    constructor() {
        //owner is the deployer
        i_owner = msg.sender;
    //interface to sepolia address
    priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }
    //the modifier (the bouncer)
    modifier onlyOwner() {
        require(msg.sender == i_owner, "You are not the Boss! Access Denied!!"); 
        _; // if the require passes, proceed
    }

    //function to open a wallet and deposit funds
    function depositFunds() public payable {
        //check of minimum deposit
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "You must send minimum 50USD!");
        //add money to the balance
        databaseBank[msg.sender].balance += msg.value;
        //if the wallet is not open, open it and add to the Array
        if (databaseBank[msg.sender].walletOn == false) {
            //open a wallet
            databaseBank[msg.sender].walletOn = true;
            //add to the array
            arrayClients.push(msg.sender);
        }
    }

    //function of withdraw
    function withdrawFund(uint256 _value) public {
        //checks
        require(_value > 0, "The value must be greater than 0!");
        require(_value <= databaseBank[msg.sender].balance, " Not enought Funds!");

        //effect
        databaseBank[msg.sender].balance -= _value;

        //Interaction
        (bool success, ) = payable(msg.sender).call{value: _value}("");
        require(success, "Error: Transaction Failed!");
    }

    //rewards (only owner)
    function distributeRewards() public onlyOwner {
        //check the list of the clients
        for (uint256 i=0; i <arrayClients.length;i++) {
            address currentClient = arrayClients[i];
            uint256 balanceClient = databaseBank[currentClient].balance;

            //give the rewards only to balance > 0
            if(balanceClient > 0){
                //5% to rewards
                uint256 reward = (balanceClient * REWARD_PERCENTAGE) /100;
                //Add to rewards locker
                databaseBank[currentClient].stakingReward += reward;
            }
        }
    }
}
