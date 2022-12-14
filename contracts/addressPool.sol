// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressPool is Ownable {
    address builderAddress = address(0);
    address ereitTokenAddress = address(0);
    address ereitGovernanceAddress = address(0);

    constructor() {}

    function getBuilderAddress() public view returns (address) {
        return builderAddress;
    }

    function getEreitTokenAddress() public view returns (address) {
        return ereitTokenAddress;
    }

    function getEreitGovernanceAddress() public view returns (address) {
        return ereitGovernanceAddress;
    }

    function setBuilderAddress(address _builderAddress) public onlyOwner {
        builderAddress = _builderAddress;
    }

    function setEreitTokenAddress(address _ereitTokenAddress) public onlyOwner {
        ereitTokenAddress = _ereitTokenAddress;
    }

    function setEreitGovernanceAddress(address _ereitGovernanceAddress)
        public
        onlyOwner
    {
        ereitGovernanceAddress = _ereitGovernanceAddress;
    }
}
