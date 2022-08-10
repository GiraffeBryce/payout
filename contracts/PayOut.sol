// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PayOut {
    
    int256 private prevPrice;
    uint8 private prevPriceDecimal;
    int256 private price;
    uint8 private priceDecimal;
    uint256 payoutAmt;
    address private _owner;
    AggregatorV3Interface public priceFeed;
    address private _priceIncreaseBetter;
    address private _priceDecreaseBetter;

    event PriceChange(uint time, int256 currentPrice);
    event FundContract(address indexed from, uint value);
    event PayOutOccurrence(address indexed winner, int256 prevPrice, int256 currPrice);

    constructor() payable {
        console.log("Hello my name is Bryce and I'm the casino owner :0");
        _owner = payable(msg.sender);
        payoutAmt = 0.0001 ether;
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        prevPrice = getLatestPrice();
        prevPriceDecimal = getLatestDecimals();
        price = getLatestPrice();
        priceDecimal = getLatestDecimals();
        _priceIncreaseBetter = payable(0xF8d61d4bf4b1E9bd35aDbDdf8561A5226A81F316);
        _priceDecreaseBetter = payable(0xCDE3727cE597B72Ebe29f0E8e9D639E694cb602C);
        emit PriceChange(block.timestamp, price);
    }

    fallback() external payable {
        emit FundContract(msg.sender, msg.value);
    }

    function getLatestPrice() public view returns (int) {
        (, int currentPrice,,,) = priceFeed.latestRoundData();
        return currentPrice;
    }

    function getLatestDecimals() public view returns (uint8) {
        uint8 decimals = priceFeed.decimals();
        return decimals;
    }

    function getPrevPrice() public view returns (int) {
        return prevPrice;
    }

    function getPrevDecimals() public view returns (uint8) {
        return prevPriceDecimal;
    }

    function getStoredPrice() public view returns (int) {
        return price;
    }

    function getStoredDecimals() public view returns (uint8) {
        return priceDecimal;
    }

    function changePrice() public {
        prevPrice = price;
        (,price,,,) = priceFeed.latestRoundData();
        emit PriceChange(block.timestamp, price);
    }

    function changePriceDecimal() public {
        prevPriceDecimal = priceDecimal;
        priceDecimal = priceFeed.decimals();
    }

    function pay() external payable {
        // require(msg.sender == _owner, "Must be owner to call pay method");
        require(payoutAmt <= address(this).balance, "Not enough funds in contract to initiate payout");
        if(price > prevPrice) {
            payable(_priceIncreaseBetter).transfer(payoutAmt);
            console.log(_priceIncreaseBetter, " is a winner!");
            emit PayOutOccurrence(_priceIncreaseBetter, prevPrice, price);
        }
        else if (price < prevPrice) {
            payable(_priceDecreaseBetter).transfer(payoutAmt);
            console.log(_priceDecreaseBetter, " is a winner!");
            emit PayOutOccurrence(_priceDecreaseBetter, prevPrice, price);
        }
        else {
            console.log("Nobody won.");
            emit PayOutOccurrence(address(0), prevPrice, price);
        }
        console.log("Pay out done.");

        changePrice();
        console.log("Changed prices.");
        changePriceDecimal();
        console.log("Change price decimals.");
        
    }
}