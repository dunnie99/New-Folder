// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {factory} from "../src/factory.sol";
import {MyERC20Token} from "../src/token.sol";
import {IORG} from "../src/IORG.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OrgTest is Test {
    factory public fac;
    MyERC20Token public token;

    address Bob = vm.addr(0x1);
    address Alice = vm.addr(0x2);
    address Bisola = vm.addr(0x3);
    address newOrg;

    function setUp() public {
        vm.startPrank(Bob);
        token = new MyERC20Token(2000);
        fac = new factory();
        vm.stopPrank();
    }

    function testcreateOrg() public {
        vm.startPrank(Bob);
        newOrg = fac.createOrg("Mytoken", "MTK", address(token), Bob);
        vm.stopPrank();
        fac.getOrganization(Bob);

         vm.startPrank(Bob);
        IORG(newOrg).addStakeholder(
            "investor",
            24 days,
            5
        );

        IORG(newOrg).addStakeholder(
            "co-founder",
            100 days,
            8
        );

        IORG(newOrg).getStakeholdersType(
            "investor"
        );

        IORG(newOrg).getStakeholdersType(
            "co-founder"
        );
        vm.stopPrank();
    }

    function testRegUsers() public{
        testcreateOrg();
        vm.startPrank(Alice);
        token.mint(Alice, 10);
        IERC20(token).approve(address(newOrg), 8);
        IORG(newOrg).registerUser(
            "co-founder",
            8,
            2 days
        );
        vm.stopPrank();

        vm.startPrank(Bisola);
        token.mint(Bisola, 10);
        IERC20(token).approve(address(newOrg), 8);
        IORG(newOrg).registerUser(
            "Investor",
            8,
            9 days
        );
        vm.stopPrank();

        IORG(newOrg).getUserInfo(
           Alice
        );

        IORG(newOrg).getUserInfo(
           Bisola
        );

    }

    function testwithdrawal() public{
        testRegUsers();
        IERC20(token).balanceOf(newOrg);

        vm.warp(130 days);

        IORG(newOrg).calInterest(
           Alice
        );
        IORG(newOrg).withdrawal(
           Alice
        );

        IORG(newOrg).calInterest(
            Bisola
        );

        IORG(newOrg).withdrawal(
           Bisola
        );

        




    }
    

    
}
