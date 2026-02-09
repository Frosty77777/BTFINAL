Music Album Crowdfunding DApp
Project overview

This project is our final examination project for the Blockchain Technology course.

WE built a simple decentralized crowdfunding application where an artist can collect funds for producing a music album. Users can support the artist by sending test ETH. For every contribution, users receive ERC-20 fan tokens that represent support and engagement.

The project is created only for educational purposes and works only on a test or local blockchain network.

Purpose of the project

The main purpose of this project is to show that We understand how:

blockchain works

smart contracts are written in Solidity

crowdfunding logic can be implemented on Ethereum

ERC-20 tokens are used

MetaMask is integrated into a web application

frontend interacts with the blockchain

Project architecture

The application consists of three main parts:

Smart contracts written in Solidity

Frontend written in HTML and JavaScript

MetaMask wallet for user interaction

Smart contracts
MusicAlbumCrowdfund.sol

This contract is responsible for:

creating crowdfunding campaigns

accepting ETH contributions

tracking user deposits

finalizing campaigns after the deadline

allowing withdraw or refund depending on the result

FanToken.sol

This is a custom ERC-20 token:

tokens are minted automatically when users contribute

tokens have no real value

tokens are used only to demonstrate tokenization

tokens represent fan support

Crowdfunding logic (simple explanation)

The artist creates a campaign with a goal and duration.

Users contribute test ETH to the campaign.

All ETH is locked inside the smart contract.

After the deadline, the campaign is finalized.

If the goal is reached:

the artist can withdraw the funds.

If the goal is not reached:

contributors can refund their ETH.

This logic guarantees fairness and transparency.

MetaMask integration

MetaMask is used to:

connect user wallets

sign transactions

send ETH contributions

interact with smart contracts

All transactions are executed through MetaMask.

Network usage

The project runs on a local Hardhat blockchain.

Only test ETH is used.

Ethereum mainnet is not used.

How to run the project

Install dependencies
'''
npm install
'''

Start local blockchain

npx hardhat node


Deploy contracts

npx hardhat run scripts/deploy.js --network localhost


Open frontend

Open frontend/index.html using Live Server

Connect MetaMask to localhost network

Import an account from Hardhat node

How to test

Create a campaign

Contribute ETH

Receive fan tokens

Wait for campaign deadline

Finalize the campaign

Test withdraw or refund

Educational note

This project is created only for learning purposes:

no real cryptocurrency is used

no real financial value exists

deployment on mainnet is forbidden

Conclusion

This project demonstrates a complete decentralized crowdfunding workflow. It shows how smart contracts, ERC-20 tokens, MetaMask, and frontend logic work together in a real blockchain-based application.

  ![kk](https://github.com/user-attachments/assets/1d30fbec-1493-4e4d-9563-beaffefd1324)

