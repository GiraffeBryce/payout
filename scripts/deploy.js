// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {

  const [deployer] = await hre.ethers.getSigners();
  const PayOutFactory = await ethers.getContractFactory("PayOut");
  const PayOutContract = await PayOutFactory.deploy();
  await PayOutContract.deployed();

  console.log("PayOut deployed to:", PayOutContract.address);
  console.log("Contract deployed by:", deployer.address);

  // let priceChange;
  // console.log("Changing price now... ");
  // priceChange = await PayOutContract.changePrice();
  // priceDecimalChange = await PayOutContract.changePriceDecimal();
  // console.log("Price has changed.");

  // Get ETH/USD price and decimals
  let prevPrice;
  console.log("Getting previous price: ");
  prevPrice = await PayOutContract.getPrevPrice();
  console.log((prevPrice.toString()));

  let prevDecimals;
  console.log("Getting previous decimals: ");
  prevDecimals = await PayOutContract.getPrevDecimals();
  console.log(prevDecimals.toString());

  let price;
  console.log("Getting current price: ");
  price = await PayOutContract.getStoredPrice();
  console.log((price.toString()));

  let decimals;
  console.log("Getting current decimals: ");
  decimals = await PayOutContract.getStoredDecimals();
  console.log(decimals.toString());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
