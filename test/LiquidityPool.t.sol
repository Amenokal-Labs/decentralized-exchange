// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/LiquidityPool.sol";

contract LiquidityPoolTest is Test {
    MyToken public tokenA;
    MyToken public tokenB;
    LiquidityPool public pool;

    
    mapping(address => uint256) public balancesA;
    mapping(address => uint256) public balancesB;

    function setUp() public {
        tokenA = new MyToken("Token A", "MTKA");
        tokenB = new MyToken("Token B", "MTKB");
        uint256 initialRate = 2;
        pool = new LiquidityPool(tokenA, tokenB, initialRate);

        uint256 allowanceA = 10000;
        tokenA.approve(address(pool), allowanceA);

        uint256 allowanceB = 10000;
        tokenB.approve(address(pool), allowanceB);
    }

    function deposit(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amount must be greater than zero");

        balancesA[msg.sender] += amountA;
        balancesB[msg.sender] += amountB;

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);
    }

    function withdraw(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amount must be greater than zero");
        require(amountA <= balancesA[msg.sender] && amountB <= balancesB[msg.sender], "Insufficient balance");

        balancesA[msg.sender] -= amountA;
        balancesB[msg.sender] -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    function exchangeAtoB(uint256 amountA, uint256 exchangeRate) external {
        require(amountA > 0, "Amount must be greater than zero");
        require(balancesA[msg.sender] >= amountA, "Insufficient tokenA balance");

        uint256 amountB = amountA * exchangeRate;

        balancesA[msg.sender] -= amountA;
        balancesB[msg.sender] += amountB;

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    function exchangeBtoA(uint256 amountB, uint256 exchangeRate) external {
        require(amountB > 0, "Amount must be greater than zero");
        require(balancesB[msg.sender] >= amountB, "Insufficient tokenB balance");

        uint256 amountA = amountB * exchangeRate;

        balancesB[msg.sender] -= amountB;
        balancesA[msg.sender] += amountA;

        tokenB.transferFrom(msg.sender, address(this), amountB);
        tokenA.transfer(msg.sender, amountA);
    }
}
