// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {factory} from "../src/factory.sol";
import {MyERC20Token} from "../src/token.sol";
import {IORG} from "../src/IORG.sol";

contract OrgTest is Test {
    factory public fac;
    MyERC20Token public token;

    address Bob = vm.addr(0x1);
    address Alice = vm.addr(0x2);
    address Bisola = vm.addr(0x3);
    address newOrg;
    function setUp() public{
        vm.startPrank(Bob);
        token = new MyERC20Token(2000);
        fac = new factory();
        vm.stopPrank();
        
    }

    function testcreateOrg() public {
        vm.prank(Bob);
          newOrg =  fac.createOrg("Mytoken", "MTK", address(token));
         //return newOrg;
    }

    function testnewOrg() public{
        vm.startPrank(Bob);
        IORG(0xc8624589Ede8b4895513755817933fa17e3eF1F3).addStakeholder("investor", 24, 5);

    }
}