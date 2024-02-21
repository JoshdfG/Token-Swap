// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken2 is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol
    ) Ownable(msg.sender) ERC20(name, symbol) {
        // Mint initial supply to the contract creator
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
