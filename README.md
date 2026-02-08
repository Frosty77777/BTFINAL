# Music Album Crowdfunding dApp

A **decentralized crowdfunding dApp** for independent music artists. Artists create campaigns to fund album production; fans contribute ETH and receive ERC-20 **Fan Tokens (FAN)** as rewards. Successful campaigns let creators withdraw funds; failed ones let contributors get refunds.

**Testnet only** (e.g. Sepolia, Holesky, or local Hardhat). Fan tokens represent fan support and engagement only — no real monetary value.

---

## Concept

- **Artists** create a campaign with a title, funding goal (ETH), and duration.
- **Fans** contribute ETH before the deadline and receive FAN tokens proportionally.
- After the **deadline**, anyone can **finalize** the campaign.
- **If goal met:** the creator can **withdraw** the raised ETH.
- **If goal not met:** contributors can **refund** their ETH.
- **FAN tokens** are minted on each contribution (1000 FAN per 1 ETH).

---

## Tech Stack

| Layer        | Technology                          |
|-------------|--------------------------------------|
| Smart contracts | Solidity ^0.8.20 (OpenZeppelin) |
| Build & deploy   | Hardhat                            |
| Frontend        | HTML, CSS, JavaScript, ethers.js v6 |
| Wallet          | MetaMask                           |
| Network         | Ethereum testnet or local node     |

---

## Project Structure

```
Music-crowdfund 3/
├── contracts/
│   ├── FanToken.sol              # ERC-20 "Music Fan Token" (FAN)
│   └── MusicAlbumCrowdfund.sol   # Campaign logic, contribute, finalize, withdraw, refund
├── scripts/
│   └── deploy.js                 # Deploys FanToken + MusicAlbumCrowdfund, transfers token ownership
├── frontend/
│   ├── index.html                # UI: connect, create, contribute, finalize, withdraw/refund
│   ├── index.js                  # Contract calls via ethers.js
│   └── style.css                 # Styles
├── hardhat.config.js
├── package.json
└── README.md
```

---

## Setup & Deployment

### 1. Install dependencies

```bash
npm install
```

### 2. (Optional) Environment for testnets

Create a `.env` in the project root:

```env
PRIVATE_KEY=your_deployer_private_key_without_0x
```

Add network config in `hardhat.config.js` if you use Sepolia/Holesky (e.g. `url` and `accounts` from env).

### 3. Compile contracts

```bash
npx hardhat compile
```

### 4. Deploy

**Local Hardhat network:**

```bash
npx hardhat node
```

In another terminal:

```bash
npx hardhat run scripts/deploy.js --network localhost
```

**Testnet (after configuring the network in `hardhat.config.js`):**

```bash
npx hardhat run scripts/deploy.js --network sepolia
# or
npx hardhat run scripts/deploy.js --network holesky
```

The script prints:

- **FanToken** contract address  
- **MusicAlbumCrowdfund** contract address  
- Confirmation that FanToken ownership was transferred to the crowdfund contract  

### 5. Use the frontend

1. Open `frontend/index.html` in a browser (or serve the `frontend/` folder with a local server).
2. In `frontend/index.js`, set `CROWDFUND_ADDRESS` and `TOKEN_ADDRESS` to the addresses from step 4.
3. Connect MetaMask (same network as deployment).
4. Create campaigns, contribute, finalize, and withdraw or refund as needed.

---

## Smart Contract Overview

### MusicAlbumCrowdfund

| Function | Description |
|----------|-------------|
| `createCampaign(_title, _goalWei, _durationSeconds)` | Create a new campaign. Goal in wei; duration in seconds from `block.timestamp`. |
| `contribute(_campaignId)` | Payable. Send ETH to the campaign; sender gets FAN tokens (rate set at deploy). |
| `finalizeCampaign(_campaignId)` | Call after deadline. Marks campaign finalized and sets success/failure from goal. |
| `withdraw(_campaignId)` | Creator only. Withdraws all raised ETH when campaign is finalized and successful. |
| `refund(_campaignId)` | Contributor only. Refunds the caller’s contribution when campaign is finalized and failed. |
| `getCampaign(_campaignId)` | View. Returns creator, title, goalWei, deadline, totalRaised, finalized, successful. |
| `campaignCount` | Public. Total number of campaigns (IDs from 1 to campaignCount). |
| `contributions(campaignId, address)` | Public. Wei contributed by an address to a campaign. |

### FanToken (ERC-20)

| Function | Description |
|----------|-------------|
| `mint(to, amount)` | Only owner (MusicAlbumCrowdfund). Mints FAN to `to`. |
| `balanceOf(account)` | Standard ERC-20 balance. |

Ownership of FanToken is transferred to the MusicAlbumCrowdfund contract at deploy so only the crowdfund contract can mint.

---

## Token Economics

- **Rate:** 1000 FAN per 1 ETH (set in `deploy.js` as `rewardRate`).
- Tokens are minted in `contribute()` using 18 decimals.
- FAN is for fan support/engagement only; no financial claim.

---

## ERC-20 Integration in Crowdfunding Logic

The platform uses the FAN ERC-20 token to reward users for supporting music album campaigns.

When a fan contributes ETH via the `contribute()` function:

1. The smart contract records the ETH amount.
2. It calculates the reward based on the predefined rate.
3. It automatically mints FAN tokens.
4. The tokens are transferred directly to the contributor’s wallet.

The minting function can only be executed by the crowdfunding smart contract because token ownership is transferred to it during deployment. This prevents unauthorized token creation.

The frontend retrieves token balances using `balanceOf()` and displays them to the user in real time.

The FAN token does not represent ownership, profit, or financial rights. It is used solely to demonstrate tokenization mechanics and supporter recognition.

---

## Frontend Usage

1. **Connect MetaMask** — Connect wallet; UI shows address, ETH balance, FAN balance.
2. **Create Campaign** — Album title, goal (ETH), duration (seconds). Example: 7 days = `604800`.
3. **Contribute** — Campaign ID and ETH amount; sends ETH and updates FAN balance.
4. **Finalize** — Campaign ID; call after the campaign deadline.
5. **Withdraw** — Campaign ID; for the campaign creator when finalized and successful.
6. **Refund** — Campaign ID; for contributors when finalized and unsuccessful.

---

## MetaMask Integration

The frontend communicates with the blockchain through the MetaMask wallet.

When the user presses **Connect Wallet**, the application:

1. Requests access to accounts using `eth_requestAccounts`;
2. Retrieves the currently selected address;
3. Verifies that the wallet is connected to the required Ethereum test network.

All state-changing operations — creating a campaign, contributing ETH, finalizing, withdrawing, and requesting refunds — are executed as transactions that must be approved and signed inside MetaMask.

MetaMask therefore acts as a secure bridge between the user interface and the smart contracts, ensuring authentication and transaction authorization.

If the wrong network is selected, the application notifies the user to switch.

---

## Security & Design Notes

- **Access:** Withdraw restricted to campaign creator; refund restricted to own contribution.
- **State:** `finalized` and `successful` prevent double finalization and enforce withdraw vs refund rules.
- **Time:** Contributions only before `deadline`; finalization only after.
- **Checks:** Non-zero goal and duration; contribution amount; ownership and campaign state in withdraw/refund.

---

## One-Line Summary

Crowdfunding dApp for music album production: create campaigns, contribute ETH, get FAN tokens; finalize after deadline; creators withdraw on success, contributors refund on failure. Built with Hardhat, Solidity, and a simple ethers.js frontend.

---

## *MusicAlbumCrowdfund Contract*
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FanToken.sol";

/*
 MusicAlbumCrowdfund
 - Artist creates a campaign to fund a music album
 - Fans contribute ETH
 - Deadline based finalization
 - Successful → artist withdraws ETH
 - Failed → fans get refunds
 - Fans receive ERC-20 reward tokens for support
*/

contract MusicAlbumCrowdfund {

    struct Campaign {
        address payable creator;
        string title;
        uint256 goalWei;
        uint256 deadline;
        uint256 totalRaised;
        bool finalized;
        bool successful;
    }

    FanToken public fanToken;
    uint256 public rewardRate; // tokens per 1 ETH
    uint256 public campaignCount;

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;

    constructor(address fanTokenAddress, uint256 _rewardRate) {
        fanToken = FanToken(fanTokenAddress);
        rewardRate = _rewardRate;
    }

    // Create a new crowdfunding campaign
    function createCampaign(
        string memory _title,
        uint256 _goalWei,
        uint256 _durationSeconds
    ) external {
        require(_goalWei > 0, "Goal must be greater than 0");
        require(_durationSeconds > 0, "Duration must be greater than 0");

        campaignCount++;

        campaigns[campaignCount] = Campaign({
            creator: payable(msg.sender),
            title: _title,
            goalWei: _goalWei,
            deadline: block.timestamp + _durationSeconds,
            totalRaised: 0,
            finalized: false,
            successful: false
        });
    }

    // Contribute ETH to a campaign
    function contribute(uint256 _campaignId) external payable {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp < campaign.deadline, "Campaign ended");
        require(msg.value > 0, "Must send ETH");

        campaign.totalRaised += msg.value;
        contributions[_campaignId][msg.sender] += msg.value;

        // Mint reward fan tokens
        uint256 rewardAmount = (msg.value * rewardRate * 1e18) / 1 ether;
        fanToken.mint(msg.sender, rewardAmount);

    }

    // Finalize campaign after deadline
    function finalizeCampaign(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp >= campaign.deadline, "Campaign still active");
        require(!campaign.finalized, "Already finalized");

        campaign.finalized = true;

        if (campaign.totalRaised >= campaign.goalWei) {
            campaign.successful = true;
        }
    }

    // Withdraw funds (only if successful)
    function withdraw(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(campaign.finalized, "Not finalized");
        require(campaign.successful, "Campaign failed");
        require(msg.sender == campaign.creator, "Not campaign creator");

        uint256 amount = campaign.totalRaised;
        campaign.totalRaised = 0;

        campaign.creator.transfer(amount);
    }

    // Refund contributors (only if failed)
    function refund(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(campaign.finalized, "Not finalized");
        require(!campaign.successful, "Campaign successful");

        uint256 contributed = contributions[_campaignId][msg.sender];
        require(contributed > 0, "Nothing to refund");

        contributions[_campaignId][msg.sender] = 0;
        payable(msg.sender).transfer(contributed);
    }

    // Helper function to get campaign info
    function getCampaign(uint256 _campaignId)
        external
        view
        returns (
            address creator,
            string memory title,
            uint256 goalWei,
            uint256 deadline,
            uint256 totalRaised,
            bool finalized,
            bool successful
        )
    {
        Campaign memory c = campaigns[_campaignId];
        return (
            c.creator,
            c.title,
            c.goalWei,
            c.deadline,
            c.totalRaised,
            c.finalized,
            c.successful
        );
    }
}


This smart contract implements a crowdfunding system for a music album.
An artist creates a campaign with a funding goal and a deadline. Fans support the project by sending ETH and receive ERC-20 fan tokens as a reward.

- **How it works**

The artist creates a campaign with a goal and duration

Fans contribute ETH before the deadline

For each contribution, reward tokens are minted

After the deadline, the campaign is finalized

- **Outcomes**

Successful campaign: if the goal is reached, the artist can withdraw the raised ETH

Failed campaign: if the goal is not reached, contributors can claim refunds

- **Key Features**

Deadline-based crowdfunding

ETH contributions tracking

ERC-20 reward token minting

Secure withdrawal and refund logic

This contract ensures transparent funding, fair rewards for supporters, and safe handling of funds on the Ethereum blockchain.

---

## *FanToken Contract*

- FanToken is an ERC-20 reward token used in the crowdfunding system to represent fan support.
It is minted and distributed to users who contribute ETH to a music album campaign.

- **Key Characteristics**

Built on the ERC-20 standard using OpenZeppelin

Token name: Music Fan Token

Symbol: FAN

Uses ownership-based access control

- **How It Works**

The contract owner is set during deployment

Only the owner can mint new tokens

Tokens are minted as rewards for supporters

- **Minting Logic**

The mint function allows the owner (typically the crowdfunding contract) to create new tokens and send them to a specified address. This ensures that fan tokens are issued only as part of the crowdfunding process.

- **Purpose**

FanToken acts as a non-financial reward token, representing engagement and support rather than ownership or profit rights.
Diagramma
![kk](https://github.com/user-attachments/assets/79d63841-2138-4c56-be2a-4907e4c4a010)
