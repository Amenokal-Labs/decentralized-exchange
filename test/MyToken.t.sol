// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    
    function setUp() public {
        myToken = new MyToken(1000);
    }
    
    function testMint() public {
        address account = address(0x123);
        uint256 amount = 100;
        
        myToken.mint(account, amount);
        
        assertEq(myToken.balanceOf(account), 100 * (10 ** uint256(myToken.decimals())), "Incorrect token balance after minting");
        assertEq(myToken.totalSupply(), 1100 * (10 ** uint256(myToken.decimals())), "Total supply is incorrect after minting");
    }
}
