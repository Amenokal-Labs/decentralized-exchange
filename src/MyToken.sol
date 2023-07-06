// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address private _owner;

    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
        _owner = msg.sender;
    }

    function mint(address recipient, uint256 amount) public {
        require(msg.sender == _owner, "Only the contract owner can mint tokens");
        _mint(recipient, amount * (10 ** uint256(decimals())));
    }
}
