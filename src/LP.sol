// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract LiquidityPool {
    using Math for uint256;

    IERC20 public tokenA;
    IERC20 public tokenB;
    address public owner;
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;
    uint256 public fee = 30; // 0.30% fee

    constructor(IERC20 _tokenA, IERC20 _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        owner = msg.sender;
    }

    function deposit(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Both amounts must be greater than 0");
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Failed to transfer tokenA");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Failed to transfer tokenB");

        uint256 liquidityMinted = calculateLiquidityAmount(amountA, amountB);
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;
    }

    function withdraw(uint256 liquidityAmount) external {
        require(liquidity[msg.sender] >= liquidityAmount, "Insufficient liquidity balance");

        uint256 amountA = liquidityAmount *(tokenA.balanceOf(address(this)))/(totalLiquidity);
        uint256 amountB = liquidityAmount *(tokenB.balanceOf(address(this)))/(totalLiquidity);

        liquidity[msg.sender] = liquidity[msg.sender]-(liquidityAmount);
        totalLiquidity = totalLiquidity -(liquidityAmount);

        require(tokenA.transfer(msg.sender, amountA), "Failed to transfer tokenA");
        require(tokenB.transfer(msg.sender, amountB), "Failed to transfer tokenB");
    }

    function swap(uint256 amountAIn) external {
        require(amountAIn > 0, "Amount must be greater than 0");

        uint256 amountBOut = calculateSwapAmount(amountAIn);
        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Failed to transfer tokenA for swap");
        require(tokenB.transfer(msg.sender, amountBOut), "Failed to transfer tokenB for swap");
    }

    function calculateLiquidityAmount(uint256 amountA, uint256 amountB) internal pure returns (uint256) {
        uint256 adjustedAmountA = amountA*(997); // 997 corresponds to 1000 - fee (0.30%)
        uint256 adjustedAmountB = amountB*(997); // 997 corresponds to 1000 - fee (0.30%)
        return  Math.sqrt(adjustedAmountA*(adjustedAmountB));
    }

    function calculateSwapAmount(uint256 amountAIn) internal view returns (uint256) {
        uint256 amountAWithFee = amountAIn*(1000); // 1000 corresponds to 1000 (100%)
        uint256 numerator = amountAWithFee*(tokenB.balanceOf(address(this)));
        uint256 denominator = tokenA.balanceOf(address(this))*(1000)+(amountAWithFee);
        return numerator/(denominator);
    }
}