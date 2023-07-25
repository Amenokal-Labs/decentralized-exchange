// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "./MyToken.sol";


contract LiquidityPool {
    MyToken public tokenA;
    MyToken public tokenB;


    mapping(address => uint256) public balancesA;
    mapping(address => uint256) public balancesB;
    uint256 public exchangeRate;
    event Deposit(address indexed user, uint256 amountA, uint256 amountB, uint256 liquidity);
    event Exchange(address indexed user, uint256 amountIn, uint256 amountOut, bool fromAToB);


    constructor(MyToken _tokenA, MyToken _tokenB, uint256 initialRate) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        exchangeRate = initialRate;
    }


    function updateExchangeRate() internal {
        uint256 totalBalanceA = tokenA.balanceOf(address(this));
        uint256 totalBalanceB = tokenB.balanceOf(address(this));


        require(totalBalanceA > 0 && totalBalanceB > 0, "Insufficient liquidity");
        // the constant product formula which equal to : K = x * y
        uint256 totalReserveWithFees = totalBalanceA * totalBalanceB;
        uint256 feeAmount = totalReserveWithFees * 3 / 1000;
        uint256 totalReserveWithoutFees = totalReserveWithFees - feeAmount;


        exchangeRate = totalReserveWithoutFees / totalBalanceA;
    }


    function deposit(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amount must be greater than zero");


        balancesA[msg.sender] += amountA;
        balancesB[msg.sender] += amountB;


        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);


        if (exchangeRate == 0) {
            updateExchangeRate();
        }


        emit Deposit(msg.sender, amountA, amountB, amountA + amountB);
    }

    function exchangeTokens(uint256 amount, bool fromAToB) external {
        require(amount > 0, "Amount must be greater than zero");


        uint256 amountOut;
        uint256 amountIn;


        if (fromAToB) {
            require(balancesA[msg.sender] >= amount, "Insufficient tokenA balance");


            amountOut = (amount * exchangeRate * 970) / 1000;
            amountIn = amount;


            balancesA[msg.sender] -= amount;
            balancesB[msg.sender] += amountOut;


            tokenA.transferFrom(msg.sender, address(this), amount);
            tokenB.transfer(msg.sender, amountOut);
        } else {
            require(balancesB[msg.sender] >= amount, "Insufficient tokenB balance");


            amountOut = (amount * 1000) / (exchangeRate * 970);
            amountIn = amount;


            balancesB[msg.sender] -= amount;
            balancesA[msg.sender] += amountOut;


            tokenB.transferFrom(msg.sender, address(this), amount);
            tokenA.transfer(msg.sender, amountOut);
        }


        updateExchangeRate();
       
        emit Exchange(msg.sender, amountIn, amountOut, fromAToB);
    }
}

