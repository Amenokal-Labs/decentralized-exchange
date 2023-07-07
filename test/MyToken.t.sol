// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract ContractTest is Test {

    MyToken token;

  
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);

    
    function setUp() public {
        token = new MyToken("MyToken","MTK");
    }

    function testName() external {
        assertEq("MyToken",token.name());
    }

    function testSymbol() external {
        assertEq("MTK", token.symbol());
    }

    function testMint() public {
        token.mint(alice, 2e18);
        assertEq(token.totalSupply(), token.balanceOf(alice));
    }
   

    
}


  
    
