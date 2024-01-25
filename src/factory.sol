// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import {Organization} from "./Org.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";
// Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
// console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

contract factory {
    mapping(address => address) adminOrg;

    function createOrg(
        string memory tokenname,
        string memory tokensymbol,
        address _token,
        address _admin
    ) public returns (address) {
        require(_admin == msg.sender, "admin doesn't correspond");
        Organization newOrg = new Organization(tokenname, tokensymbol, _token, _admin);
        address newAdd = address(newOrg);
        adminOrg[msg.sender] = newAdd;
        return newAdd;
    }

    function getOrganization(address newOwner) public view returns (address) {
        require(address(newOwner) != address(0), "address Zero");
        address org = adminOrg[newOwner];
        return org;
    }
}
