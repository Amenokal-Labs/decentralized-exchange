// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;

    function setUp() public {
        myToken = new MyToken();
    }

    function testInitialSupply() public {
        assertEq(myToken.totalSupply(), 0, "Initial supply should be zero");
    }

    function testTokenNameAndSymbol() public {
        assertEq(myToken.name(), "MyToken", "Token name is incorrect");
        assertEq(myToken.symbol(), "MTK", "Token symbol is incorrect");
    }

    function testMint() public {
        address account = address(0x123);
        uint256 amount = 100;
        myToken.mint(account, amount);
        assertEq(myToken.balanceOf(account), amount, "Incorrect token balance after minting");
    }

    function testBurn() public {
        address account = address(0x123);
        uint256 amount = 50;
        myToken.mint(account, amount);
        myToken.burn(account, amount);
        assertEq(myToken.balanceOf(account), 0, "Incorrect token balance after burning");
    }

    function testTransfer() public {
        address account1 = address(0x123);
        address account2 = address(0x456);
        uint256 amount = 50;
        myToken.mint(account1, amount);
        myToken.transfer(account2, amount);
        assertEq(myToken.balanceOf(account1), 0, "Incorrect token balance after transfer");
        assertEq(myToken.balanceOf(account2), amount, "Incorrect token balance after transfer");
    }
}
