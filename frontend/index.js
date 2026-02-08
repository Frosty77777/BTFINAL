const CROWDFUND_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
const TOKEN_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

const crowdfundABI = [
    "function createCampaign(string,uint256,uint256)",
    "function contribute(uint256) payable",
    "function finalizeCampaign(uint256)",
    "function withdraw(uint256)",
    "function refund(uint256)"
];

const tokenABI = [
    "function balanceOf(address) view returns (uint256)"
];

let provider, signer, crowdfund, token, user;

async function connect() {
    provider = new ethers.BrowserProvider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer = await provider.getSigner();
    user = await signer.getAddress();

    crowdfund = new ethers.Contract(CROWDFUND_ADDRESS, crowdfundABI, signer);
    token = new ethers.Contract(TOKEN_ADDRESS, tokenABI, provider);

    document.getElementById("address").innerText = user;
    updateBalances();
}

async function updateBalances() {
    const eth = await provider.getBalance(user);
    document.getElementById("eth").innerText = ethers.formatEther(eth);

    const fan = await token.balanceOf(user);
    document.getElementById("fan").innerText = ethers.formatEther(fan);
}

async function createCampaign() {
    const title = document.getElementById("title").value;
    const goal = ethers.parseEther(document.getElementById("goal").value);
    const duration = document.getElementById("duration").value;

    const tx = await crowdfund.createCampaign(title, goal, duration);
    await tx.wait();
    alert("Campaign created!");
}

async function contribute() {
    const id = document.getElementById("cid").value;
    const value = ethers.parseEther(document.getElementById("amount").value);

    const tx = await crowdfund.contribute(id, { value });
    await tx.wait();
    updateBalances();
    alert("Contribution sent!");
}

async function finalize() {
    const id = document.getElementById("fid").value;
    const tx = await crowdfund.finalizeCampaign(id);
    await tx.wait();
    alert("Campaign finalized");
}

async function withdraw() {
    const id = document.getElementById("rid").value;
    const tx = await crowdfund.withdraw(id);
    await tx.wait();
    alert("Funds withdrawn");
}

async function refund() {
    const id = document.getElementById("rid").value;
    const tx = await crowdfund.refund(id);
    await tx.wait();
    alert("Refund successful");
}