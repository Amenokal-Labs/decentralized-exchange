// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/LP.sol"; 
import "../src/MyToken.sol";


contract LiquidityPoolTest is Test {
    MyToken tokenA;
    MyToken tokenB;
    LiquidityPool liquidityPool;
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);

    function setUp() public {
        tokenA = new MyToken("TokenA", "TA"); // Deploy your tokens A and B here
        tokenB = new MyToken("TokenB", "TB");
        liquidityPool = new LiquidityPool(tokenA, tokenB); // Deploy your LiquidityPool contract here
    }

    function testDepositAndWithdraw() public {
        // Test deposit and withdraw functions of the LiquidityPool contract
        tokenA.mint(alice, 1000e18);
        tokenB.mint(alice, 2000e18);

        tokenA.approve(address(liquidityPool), 500e18);
        tokenB.approve(address(liquidityPool), 1000e18);

        liquidityPool.deposit(500e18, 1000e18);
        assertEq(liquidityPool.liquidity(alice), 1000e18);

        liquidityPool.withdraw(500e18);
        assertEq(liquidityPool.liquidity(alice), 500e18);
    }

    function testSwap() public {
        // Test swap function of the LiquidityPool contract
        tokenA.mint(alice, 1000e18);
        tokenB.mint(alice, 2000e18);

        tokenA.approve(address(liquidityPool), 500e18);
        tokenB.approve(address(liquidityPool), 1000e18);

        liquidityPool.deposit(500e18, 1000e18);
        assertEq(liquidityPool.liquidity(alice), 1000e18);

        uint256 balanceBeforeSwap = tokenB.balanceOf(alice);
        liquidityPool.swap(100e18);
        uint256 balanceAfterSwap = tokenB.balanceOf(alice);

        assert(balanceAfterSwap > balanceBeforeSwap); // Ensure tokenB balance increased after the swap
    }
}
