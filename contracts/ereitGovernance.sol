// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./addressPool.sol";
import "./ereitToken.sol";

contract EREITGoverance {
    address addressPool;

    constructor(address _addressPool) {
        addressPool = _addressPool;
    }

    /*
        making it public for now but this will be minted only when new block is added to our side blockchain to Polygon, 
        and that blockchain will be backed by trusted token Ether
    */

    function mint(address to, uint256 amount) public {
        EREIT(AddressPool(addressPool).getEreitTokenAddress()).mint(to, amount);
    }
}
