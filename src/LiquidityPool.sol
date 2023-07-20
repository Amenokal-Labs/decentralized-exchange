// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "../src/MyToken.sol";

contract LiquidityPool {
    MyToken public tokenA;
    MyToken public tokenB;

    mapping(address => uint256) public balancesA;
    mapping(address => uint256) public balancesB;

    uint256 public exchangeRate; // Storage variable for the exchange rate

    constructor(MyToken _tokenA, MyToken _tokenB, uint256 initialRate) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        exchangeRate = initialRate; 
    }

    // Update the exchange rate based on the constant product formula
    function updateExchangeRate() internal {
        require(balancesA[msg.sender] > 0 && balancesB[msg.sender] > 0, "Insufficient liquidity");

        exchangeRate = balancesB[msg.sender] / balancesA[msg.sender];
    }

    function deposit(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amount must be greater than zero");

        balancesA[msg.sender] += amountA;
        balancesB[msg.sender] += amountB;

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        updateExchangeRate(); 
    }

    function withdraw(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amount must be greater than zero");
        require(amountA <= balancesA[msg.sender] && amountB <= balancesB[msg.sender], "Insufficient balance");

        balancesA[msg.sender] -= amountA;
        balancesB[msg.sender] -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        updateExchangeRate(); 
    }

    function exchangeTokens(uint256 amount, bool fromAToB) external {
        require(amount > 0, "Amount must be greater than zero");

        if (fromAToB) {
            require(balancesA[msg.sender] >= amount, "Insufficient tokenA balance");

            uint256 amountB = amount * exchangeRate;

            balancesA[msg.sender] -= amount;
            balancesB[msg.sender] += amountB;

            tokenA.transferFrom(msg.sender, address(this), amount);
            tokenB.transfer(msg.sender, amountB);
        } else {
            require(balancesB[msg.sender] >= amount, "Insufficient tokenB balance");

            uint256 amountA = amount / exchangeRate;

            balancesB[msg.sender] -= amount;
            balancesA[msg.sender] += amountA;

            tokenB.transferFrom(msg.sender, address(this), amount);
            tokenA.transfer(msg.sender, amountA);
        }

        updateExchangeRate();
    }
}
