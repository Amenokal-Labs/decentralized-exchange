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
    assertEq(myToken.symbol(), "LDN", "Token symbol is incorrect");
}
}