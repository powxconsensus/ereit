// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EREIT is ERC20, ERC20Burnable, Ownable {
    address addressPool;

    constructor(address _addressPool) ERC20("EREIT Token", "EREIT") {
        addressPool = _addressPool;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
