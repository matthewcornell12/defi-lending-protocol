const hre = require("hardhat");

async function main() {
  // Get the current block number
  const blockNumber = await hre.ethers.provider.getBlockNumber();
  console.log("Current block number:", blockNumber);

  // Get network information
  const network = await hre.ethers.provider.getNetwork();
  console.log("Network:", {
    name: network.name,
    chainId: network.chainId
  });

  // Get your account balance
  const [signer] = await hre.ethers.getSigners();
  const balance = await hre.ethers.provider.getBalance(signer.address);
  console.log("Account:", signer.address);
  console.log("Balance:", hre.ethers.formatEther(balance), "ETH");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});