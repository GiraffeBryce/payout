const hre = require("hardhat");

async function main() {

  const contractAddress = "0x7415a2A3DD0676Df93786B4046638E83f60926a3";
  const PayOutContract = await hre.ethers.getContractAt("PayOut", contractAddress);
  console.log("PayOut deployed on this address:", PayOutContract.address);

  let currentPrice;
  console.log("Getting current price now... ");
  currentPrice = await PayOutContract.getStoredPrice();
  console.log("Current price: ", currentPrice);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
