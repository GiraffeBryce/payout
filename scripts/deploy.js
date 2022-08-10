// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

async function main() {

  const [deployer] = await hre.ethers.getSigners();
  const PayOutFactory = await ethers.getContractFactory("PayOut");
  const PayOutContract = await PayOutFactory.deploy({value: ethers.utils.parseEther(".01")});
  await PayOutContract.deployed();

  console.log("PayOut deployed to:", PayOutContract.address);
  console.log("Contract deployed by:", deployer.address);

  let payout;
  console.log("Testing payout now... ");
  payout = await PayOutContract.pay();
  console.log("Payout is finished.");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
