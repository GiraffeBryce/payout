const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PayOut", function () {
  it("Should return the new greeting once it's changed", async function () {
    const PayOutFactory = await ethers.getContractFactory("PayOut");
    const PayOutContract = await PayOutFactory.deploy();
    await PayOutContract.deployed();

    const setGreetingTx = await PayOut.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await PayOut.greet()).to.equal("Hola, mundo!");
  });
});
