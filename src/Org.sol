// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Organization is ERC20 {
    //Events
    event memberAdded(address user, bool iswhitelisted);
    event vestedReturned(
        address user,
        uint256 vestedAmount,
        uint256 rewardToken
    );

    //deployer
    address public admin;
    address public tokenVested;
    string tokenVestedName;
    string tokenVestedSym;
    uint256 totalInPool;

    // Type of stakeholder
    struct Holder {
        uint256 timelock;
        uint256 minimalAmount;
    }

    // User info
    struct User {
        string role;
        bool isWhitelisted;
        uint256 investedAmount;
        uint256 startTime;
        uint256 withdrawalTimestamp;
    }

    mapping(address => User) public UserInfo;
    mapping(string => Holder) public Holders;
    
    function onlyAdmin () view internal{
         require(msg.sender == admin, "Not authorized");
    }

    constructor(
        string memory _name,
        string memory _symbol,
        address _tokenVested
    ) ERC20("Reward", "RWD") {
        admin = msg.sender;
        tokenVested = _tokenVested;
        tokenVestedName = _name;
        tokenVestedSym = _symbol;
    }

    //201 600
    function addStakeholder(
        string memory _holder,
        uint256 _vestingPeriod,
        uint256 _minimalAmount
    ) external  {
        onlyAdmin();
        Holders[_holder] = Holder({
            timelock: _vestingPeriod,
            minimalAmount: _minimalAmount
        });
    }

    function getStakeholdersType(
        string memory _typename
    ) public view returns (uint256, uint256) {
        uint256 vestingtime = Holders[_typename].timelock;
        uint256 minAmountVest = Holders[_typename].minimalAmount;
        return (vestingtime, minAmountVest);
    }

    function registerUser(
        string memory _holderType,
        uint256 _vestAmount,
        uint256 _withdrawalStamp
    ) public {
        require(
            _vestAmount >= Holders[_holderType].minimalAmount,
            "Invalid stake amount"
        );
        IERC20(tokenVested).transferFrom(
            msg.sender,
            address(this),
            _vestAmount
        );
        UserInfo[msg.sender] = User({
            role: _holderType,
            isWhitelisted: true,
            investedAmount: _vestAmount,
            startTime: block.timestamp,
            withdrawalTimestamp: Holders[_holderType].timelock +
                _withdrawalStamp
        });
        totalInPool += _vestAmount;

        emit memberAdded(msg.sender, true);
    }

    function getUserInfo(
        address _user
    ) public view returns (string memory, bool, uint256, uint256, uint256) {
        User storage ms = UserInfo[_user];
        return (
            ms.role,
            ms.isWhitelisted,
            ms.investedAmount,
            ms.startTime,
            ms.withdrawalTimestamp
        );
    }

    function calInterest(address _user) internal view returns (uint256) {
        calVesttime(_user);
        uint256 staked = UserInfo[_user].investedAmount;
        uint256 userFrac = (staked / totalInPool) * 20;
        return userFrac;
    }

    function calVesttime(address _user) internal view {
        uint256 drawTime = UserInfo[_user].withdrawalTimestamp;
        require(block.timestamp > drawTime, "Lock time still on");
    }

    function withdrawal(address _user) public {
        User storage ms = UserInfo[_user];
        require(ms.isWhitelisted == true, "user not whitelisted");
        uint256 intr = calInterest(_user);
        uint256 returnvalue = ms.investedAmount;
        ms.investedAmount = 0;
        ms.startTime = 0;
        ms.withdrawalTimestamp = 0;
        _mint(_user, intr);
        IERC20(tokenVested).transferFrom(address(this), _user, returnvalue);
        emit vestedReturned(_user, returnvalue, intr);
    }
}
