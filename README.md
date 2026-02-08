# Music Album Crowdfunding DApp

**Blockchain Technology — Final Examination Project**

A decentralized crowdfunding application where artists raise test ETH for album production. Supporters receive ERC-20 fan tokens (FAN) for each contribution. Built with **Hardhat only** (no Remix). For educational use; test networks only.

---

## Project Overview

- **Artists** create campaigns with a funding goal and deadline.
- **Supporters** send test ETH to a campaign and automatically receive FAN tokens (1,000 FAN per 1 ETH).
- **Campaigns** can be finalized after the deadline; FAN tokens represent fan support and have no monetary value.

The project demonstrates: Solidity smart contracts, ERC-20 tokens, Hardhat toolchain, and frontend–blockchain interaction via MetaMask.

---

## Architecture

| Layer | Technology |
|-------|------------|
| Smart contracts | Solidity (Crowdfunding.sol, FanToken.sol) |
| Build & deploy | Hardhat, Ethers.js |
| Frontend | HTML, CSS, JavaScript |
| Wallet | MetaMask |

### Smart Contracts

- **`Crowdfunding.sol`** — Creates campaigns, accepts ETH contributions, mints FAN tokens to contributors, and finalizes campaigns after the deadline.
- **`FanToken.sol`** — ERC-20 "FAN" token; only the Crowdfunding contract can mint. Tokens are rewards for support only, no real value.

### Flow (simplified)

1. Artist creates a campaign (title, goal in wei, deadline).
2. Users contribute test ETH; for each contribution they receive 1,000 FAN per 1 ETH.
3. After the deadline, anyone can call `finalizeCampaign(campaignId)`.
4. ETH stays in the contract; FAN tokens represent engagement only.

---

## Project Structure (Music folder)

```
Music/
├── contracts/
│   ├── Crowdfunding.sol
│   └── FanToken.sol
├── scripts/
│   └── deploy.js
├── test/
│   └── Crowdfunding.test.js
├── frontend-music/
│   ├── index.html
│   ├── app-music.js
│   └── styles.css
├── hardhat.config.js
├── package.json
└── .env.example
```

---

## How to Run

All commands are run from the **`Music`** directory.

### 1. Install dependencies

```bash
cd Music
npm install
```

### 2. Compile contracts

```bash
npx hardhat compile
```

### 3. Run tests

```bash
npx hardhat test
```

### 4. Deploy (choose one)

**Option A — In-memory Hardhat network (quick):**

```bash
npx hardhat run scripts/deploy.js
```

**Option B — Local node (for frontend):**

Terminal 1:

```bash
npx hardhat node
```

Terminal 2:

```bash
npx hardhat run scripts/deploy.js --network localhost
```

**Option C — Sepolia testnet:**

1. Copy `.env.example` to `.env`.
2. Set `PRIVATE_KEY` to a **test account** private key (do not use mainnet).
3. Get Sepolia ETH from a faucet (e.g. [sepoliafaucet.com](https://sepoliafaucet.com)).
4. Run:

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

### 5. Use the frontend

1. Open `frontend-music/index.html` (e.g. with Live Server).
2. In MetaMask, add the local network: URL `http://127.0.0.1:8545`, Chain ID `31337`.
3. Import an account using a private key from the Hardhat node output (or use the default test account).
4. Paste the deployed **Crowdfunding** and **FanToken** addresses from the deploy script output into the frontend.
5. Create campaigns, contribute test ETH, and check your FAN balance.

---

## Networks

| Network | Use |
|---------|-----|
| **Hardhat** (default) | Compile, test, one-off deploy. |
| **localhost** | Persistent local node for frontend. |
| **Sepolia** | Public testnet; set `PRIVATE_KEY` in `.env`. |

Only test ETH is used. **Ethereum mainnet is not used.**

---

## MetaMask

MetaMask is used to:

- Connect the user's wallet.
- Sign transactions (create campaign, contribute).
- Display FAN token balance.

All on-chain actions go through MetaMask.

---

## Security Note (.env)

- Use a **test-only** account for `PRIVATE_KEY` in `.env`.
- Do not use your mainnet wallet key.
- Never commit `.env`; it is listed in `.gitignore`.

---

## Educational Disclaimer

This project is for learning only:

- No real cryptocurrency or financial value.
- Test networks and test ETH only.
- Not for mainnet deployment in this form.

---

## Summary

The DApp shows a full flow: Solidity crowdfunding + ERC-20 rewards, Hardhat for compile/deploy/test, and a simple frontend with MetaMask for a blockchain-based crowdfunding experience.
