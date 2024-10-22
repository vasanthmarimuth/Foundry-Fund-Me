# FundMe Smart Contract

A smart contract that allows users to fund a project with Ether, ensuring a minimum contribution threshold in USD. The contract owner can withdraw the accumulated funds.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [License](#license)

## Features

- Users can fund the contract by sending Ether.
- A minimum funding value of 50 USD is enforced.
- The contract owner can withdraw funds at any time.
- Includes a price feed integration to convert ETH to USD using Chainlink oracles.
- Supports multiple funding contributors.

## Technologies Used

- Solidity ^0.8.10
- Chainlink Price Feed
- Foundry (for development and testing)

## License

- This project is licensed under the MIT License. 

