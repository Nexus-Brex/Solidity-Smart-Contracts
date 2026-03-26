# Solidity-Smart-Contracts
(My personal vault of Solidity smart contracts, starting from basics to advanced DeFi).

CentralBank Smart Contract

This repository contains the code for a basic decentralized bank Smart Contract. It tracks my ongoing learning progress in Solidity and Smart Contract development.

Learning Progression:
- **V1 to V3**: Initial versions built within a single file. These iterations focus on understanding basic state variables, mappings, access control (modifiers), and simple deposit/withdraw functions.
- **V4 (Modular Architecture):** The code has been refactored into a multi-file structure to improve code readability and separate logic.

Key Features implemented in V4
- **Chainlink Integration:** Uses `AggregatorV3Interface` to fetch live ETH/USD price data.
- **PriceConverter Library:** A custom library to handle external math and conversion logic.
- **CEI Pattern:** Implementation of the Checks-Effects-Interactions pattern in the withdrawal function to mitigate Reentrancy risks.
- **Data Structures:** Utilization of a `Client` struct to manage individual user balances and staking rewards.
- **Reward Distribution:** A basic `for` loop to distribute a percentage-based reward to active users (callable only by the owner).

Currently transitioning to Foundry for local testing and security analysis.
