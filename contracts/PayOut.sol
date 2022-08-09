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

    event NewBet(address indexed from, bool guess);
    event PriceChange(uint time, int256 currentPrice);
    event FundContract(address indexed from, uint value);
    event PayOutOccurrence(address indexed winner);

    struct Bet {
        address payable better;
        bool guessUp;
    }

    Bet[] bets;
    Bet[] correctBets;

    constructor() payable {
        console.log("Hello my name is Bryce and I'm the casino owner :0");
        _owner = payable(msg.sender);
        payoutAmt = 0.0001 ether;
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        prevPrice = getLatestPrice();
        prevPriceDecimal = getLatestDecimals();
        price = getLatestPrice();
        priceDecimal = getLatestDecimals();
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

    function bet(bool guess) external {
        //Create bet
        Bet memory betMade = Bet(payable(msg.sender), guess);
        bets.push(betMade);
        console.log("Another bet made: ");
        if (guess) {
            console.log("Bet price would go up.");
        }
        else {
            console.log("Bet price would go down.");
        }

        emit NewBet(msg.sender, guess);
    }

    function getBets() public view returns (Bet[] memory) {
        console.log("Bets size: ", bets.length);
        return bets;
    }

    function pay() external payable {
        // require(msg.sender == _owner, "Must be owner to call pay method");
        require(prevPrice != price, "Prices are still the same, can't pay out");
        require(bets.length != 0, "No bets currently made, can't pay out");
        bool truePriceDirection;
        if(price > prevPrice) {
            truePriceDirection = true;
        }
        else {
            truePriceDirection = false;
        }
        
        // iterate through bets to find closest bet
        for(uint i=0; i<bets.length; i++){
            if(bets[i].guessUp == truePriceDirection) {
                correctBets.push(bets[i]);
                console.log("Another winner: ", bets[i].better);
            }
            else {
                console.log("This person didn't win:", bets[i].better);
            }
        }
            
        console.log("Current correctBets size:", correctBets.length);
        assert(correctBets.length * payoutAmt <= address(this).balance);

        for(uint i=0; i<correctBets.length; i++){
            correctBets[i].better.transfer(payoutAmt);
            console.log(correctBets[i].better, "is a winner!");
            emit PayOutOccurrence(correctBets[i].better);
        }
        console.log("Pay out done.");

        delete bets;
        console.log("Bets reset. Size: ", bets.length);
        delete correctBets;
        console.log("Correct bets reset. Size: ", correctBets.length);
    }
}