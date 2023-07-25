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

    function testDeposit() public {
        uint256 amountA = 1000;
        uint256 amountB = 2000;

        tokenA.mint(address(this), amountA);
        tokenB.mint(address(this), amountB);

        tokenA.approve(address(pool), amountA);
        tokenB.approve(address(pool), amountB);

        assertEq(tokenA.balanceOf(address(this)), amountA);
        assertEq(tokenB.balanceOf(address(this)), amountB);
        assertEq(tokenA.balanceOf(address(pool)), 0);
        assertEq(tokenB.balanceOf(address(pool)), 0);

        pool.deposit(amountA, amountB);

        assertEq(tokenA.balanceOf(address(this)), 0);
        assertEq(tokenB.balanceOf(address(this)), 0);
        assertEq(tokenA.balanceOf(address(pool)), amountA);
        assertEq(tokenB.balanceOf(address(pool)), amountB);
    }

    function testExchangeTokens() public {
        uint256 amountA = 1000;
        uint256 amountB = 2000;
        uint256 exchangeAmount = 500;

        pool.deposit(amountA, amountB);

        assertEq(pool.exchangeRate(), 2);

        pool.exchangeTokens(exchangeAmount, true);

        assertEq(pool.exchangeRate(), 1);
        assertEq(tokenA.balanceOf(address(pool)), amountA + exchangeAmount);
        assertEq(tokenB.balanceOf(address(pool)), amountB - exchangeAmount);

        pool.exchangeTokens(exchangeAmount, false);

        assertEq(pool.exchangeRate(), 2);
        assertEq(tokenA.balanceOf(address(pool)), amountA);
        assertEq(tokenB.balanceOf(address(pool)), amountB);
    }
}
