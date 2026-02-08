# Music Album Production Crowdfunding — Blockchain Exam Project

**Decentralized crowdfunding DApp for independent music artists** — Built with Hardhat, Solidity, and MetaMask. Testnet only (Sepolia/Holesky).

---

## 🎵 Project Concept

Independent artists create crowdfunding campaigns to raise funds for producing and releasing music albums. Contributors receive ERC-20 **Fan Tokens (FAN)** as rewards representing fan support and engagement. **Reward tokens represent fan support and engagement only** — no real monetary value.

---

## 🧱 Technology Stack

- **Solidity** — Smart contracts (0.8.20)
- **Hardhat** — Development and deployment
- **JavaScript** — Frontend + deployment scripts
- **ethers.js** — Contract interaction
- **MetaMask** — Wallet and transactions
- **Ethereum Testnet** — Sepolia or Holesky

---

## 📁 Project Structure

```
BloodTestCrowdfunding/
├── contracts/
│   ├── FanToken.sol              # ERC-20 fan token (FAN)
│   └── AlbumCrowdfunding.sol    # Campaign logic with modifiers
├── scripts/
│   └── deploy-music.js           # Deployment script
├── frontend-music/
│   ├── index.html               # Music-themed UI
│   ├── app-music.js             # Frontend logic
│   └── styles.css
├── hardhat.config.js
├── package.json
└── MUSIC_README.md
```

---

## 🔐 Security Features & Design

### Modifiers (Security Best Practices)

- **`campaignExists(uint256 _campaignId)`** — Ensures campaign exists
- **`notFinalized(uint256 _campaignId)`** — Prevents double finalization
- **`beforeDeadline(uint256 _campaignId)`** — Prevents contributions after deadline
- **`afterDeadline(uint256 _campaignId)`** — Ensures finalization only after deadline

### Error Handling

- Custom errors (gas-efficient): `CampaignNotFound`, `CampaignAlreadyFinalized`, `CampaignDeadlineNotReached`, `CampaignDeadlinePassed`, `InvalidAmount`, `InvalidDeadline`, `InvalidTitle`
- Zero-address checks
- Input validation (title, goal, deadline)

### State Management

- Safe storage of campaign data
- Per-user contribution tracking
- Finalization flag prevents double finalization

---

## 🚀 Setup & Deployment

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Edit `.env`: set `PRIVATE_KEY` (deployer private key, no `0x` prefix).

### 3. Compile Contracts

```bash
npm run compile
```

### 4. Deploy to Testnet

**Sepolia:**
```bash
hardhat run scripts/deploy-music.js --network sepolia
```

**Holesky:**
```bash
hardhat run scripts/deploy-music.js --network holesky
```

**Local Hardhat:**
```bash
hardhat run scripts/deploy-music.js
```

The script will output:
- FanToken (FAN) address
- AlbumCrowdfunding address

---

## 🎯 Smart Contract Functions

### AlbumCrowdfunding

- **`createCampaign(title, fundingGoal, deadline)`** — Create album campaign
- **`contribute(campaignId)`** — Contribute test ETH (payable), receives FAN tokens
- **`finalizeCampaign(campaignId)`** — Finalize after deadline (album released)
- **`getCampaignCount()`** — Get total campaigns
- **`getContribution(campaignId, contributor)`** — Get user's contribution
- **`checkContribution(campaignId, contributor)`** — Check if user contributed

### FanToken

- **`mint(to, amount)`** — Mint tokens (only by AlbumCrowdfunding)
- **`setMinter(address)`** — Set minter (onlyOwner)

---

## 🖥️ Frontend Usage

1. Open `frontend-music/index.html` in a browser
2. **Connect MetaMask** — validates Sepolia/Holesky
3. Paste **Crowdfunding** and **FanToken** addresses (from deployment)
4. **Create Campaign**: Album title, goal (ETH), deadline (use "7 days" button or Unix timestamp)
5. **Contribute**: Campaign ID + amount (ETH) — receives 1000 FAN per 1 ETH
6. **Finalize**: Campaign ID after deadline
7. **Refresh** to see campaign progress and finalized status

---

## 📊 Token Economics

- **1000 FAN tokens per 1 ETH** contributed
- Tokens minted automatically on contribution
- **Reward tokens represent fan support and engagement** — no financial value
- Educational purposes only

---

## ✅ Exam Requirements Checklist

| Requirement | Implementation |
|-------------|----------------|
| Create campaigns (title, goal, deadline) | ✓ `createCampaign()` |
| Accept ETH contributions | ✓ `contribute()` payable |
| Track individual contributions | ✓ `contributions` mapping + `getContribution()` |
| Prevent contributions after deadline | ✓ `beforeDeadline` modifier |
| Finalize after deadline | ✓ `finalizeCampaign()` + `afterDeadline` modifier |
| ERC-20 FanToken | ✓ `FanToken.sol` |
| Mint on contribution, proportional | ✓ 1000 FAN per 1 ETH |
| Security modifiers | ✓ `campaignExists`, `notFinalized`, `beforeDeadline`, `afterDeadline` |
| Prevent double finalization | ✓ `notFinalized` modifier + `finalized` flag |
| Hardhat deployment | ✓ `deploy-music.js` |
| MetaMask integration | ✓ Frontend: connect, network check, transactions |
| Testnet only | ✓ Sepolia/Holesky validation |

---

## 🎓 Key Concepts Explained

### Modifiers

Modifiers are reusable checks applied to functions:

```solidity
modifier beforeDeadline(uint256 _campaignId) {
    if (block.timestamp >= campaigns[_campaignId].deadline) 
        revert CampaignDeadlinePassed();
    _;  // Continue function execution
}
```

### Custom Errors

More gas-efficient than `require` strings:

```solidity
error CampaignDeadlinePassed();
// Usage:
if (block.timestamp >= deadline) revert CampaignDeadlinePassed();
```

### Token Minting

When a user contributes ETH, tokens are minted proportionally:

```solidity
uint256 tokensToMint = (msg.value * TOKENS_PER_ETH) / 1e18;
fanToken.mint(msg.sender, tokensToMint);
```

---

## 🎵 One-Line Summary

Crowdfunding DApp for music album production with ERC-20 fan tokens, built with Hardhat, deployed to Ethereum testnet, featuring security modifiers and MetaMask integration.
