const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  const provider = ethers.provider;

  console.log("Deploying with account:", deployer.address);

  const balance = await provider.getBalance(deployer.address);
  console.log("Balance:", ethers.formatEther(balance), "ETH");

  // 1. Deploy FanToken (owner = deployer temporarily)
  const FanToken = await ethers.getContractFactory("FanToken");
  const fanToken = await FanToken.deploy(deployer.address);
  await fanToken.waitForDeployment();

  console.log("FanToken deployed to:", await fanToken.getAddress());

  // 2. Deploy Crowdfunding
  const rewardRate = 1000; // 1000 FAN per 1 ETH

  const Crowdfund = await ethers.getContractFactory("MusicAlbumCrowdfund");
  const crowdfund = await Crowdfund.deploy(
    await fanToken.getAddress(),
    rewardRate
  );
  await crowdfund.waitForDeployment();

  console.log("Crowdfund deployed to:", await crowdfund.getAddress());

  // 3. Transfer token ownership to Crowdfunding
  const tx = await fanToken.transferOwnership(await crowdfund.getAddress());
  await tx.wait();

  console.log("FanToken ownership transferred to Crowdfund");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
