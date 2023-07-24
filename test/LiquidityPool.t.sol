// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/LiquidityPool.sol";


contract LiquidityPoolTest is Test {
    MyToken public tokenA;
    MyToken public tokenB;
    LiquidityPool public pool;

    function beforeEach() public {
        tokenA = new MyToken("TokenA", "MTK"); 
        tokenB = new MyToken("TokenB", "MTK"); 
        pool = new LiquidityPool(tokenA, tokenB, 2); 
    }
}