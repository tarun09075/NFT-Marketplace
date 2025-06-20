const hre = require("hardhat");

async function main() {
  // Compile the contracts if needed
  await hre.run("compile");

  // Deploy the contract to Core Testnet
  const NFTMarketplace = await hre.ethers.getContractFactory("SimpleNFTMarketplace");
  const nftMarketplace = await NFTMarketplace.deploy();

  await nftMarketplace.deployed();

  console.log("SimpleNFTMarketplace deployed to:", nftMarketplace.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
