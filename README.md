Betting contract where users can bet on whether the price of ETH/USD goes up or down, winner gets .0001 ether

Update 8/9/22: Modify contract so that it's not taking bets anymore. Now, it pays out to 1 of 2 of my addresses based on whether the price of ETH/USD goes up or not.

Tips for how to run this project:
-Make a .env file with:
    - An alchemy key for a variable called TEST_ALCHEMY_KEY
    - An Etherscan API key (for contract verification) called ETHERSCAN_API_KEY
    - A private key for an address you own with Rinkeby ETH in it for contract deployment called PRIVATE_KEY
-Include the following code in your hardhat config file underneath the solidity version:

networks: {
    rinkeby: {
      url: process.env.TEST_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    }
},
etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
}

-Run: npx hardhat run scripts/deploy.js --network rinkeby
-Verify the contract on Etherscan: npx hardhat verify "(contract address)" --network rinkeby