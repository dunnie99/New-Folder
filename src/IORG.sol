// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

interface IORG {
    function addStakeholder(
        string memory _holder,
        uint256 _vestingPeriod,
        uint256 _minimalAmount
    ) external;

    function getStakeholdersType(
        string memory _typename
    ) external view returns (uint256, uint256);

    function registerUser(
        string memory _holderType,
        uint256 _vestAmount,
        uint256 _withdrawalStamp
    ) external;

    function getUserInfo(
        address _user
    ) external view returns (string memory, bool, uint256, uint256, uint256);

    function calInterest(address _user) external view returns (uint256);

    function withdrawal(address _user) external;
}
