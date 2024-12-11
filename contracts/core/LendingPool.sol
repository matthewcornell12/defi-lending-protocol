// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract LendingPool is ReentrancyGuard, Pausable {
    // Constants
    uint256 constant MIN_COLLATERAL_RATIO = 150; // 150% collateralization required

    // State Variables
    mapping (address => uint256) public userCollateral;
    uint256 public totalCollateral;

    mapping (address => uint256) public userBorrowed;
    uint256 public totalBorrowed;


    // Event definitions
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    event FundsBorrowed(address indexed user, uint256 amount);
    event FundsRepaid(address indexed user, uint256 amount, uint256 balanceRemaining);

    // Function definitions
    function deposit() public payable nonReentrant {
        require(msg.value > 0, "User must deposit more than 0 ETH");

        userCollateral[msg.sender] += msg.value;
        totalCollateral += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdrawal(uint256 amount) public nonReentrant {
        require(userCollateral[msg.sender] >= amount, "Cannot withdraw more ETH than user's balance");
        totalCollateral -= amount;
        userCollateral[msg.sender] -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal Failed");
        emit Withdrawal(msg.sender, amount);
    }

    function borrowFunds(uint256 amount) public nonReentrant {
        uint256 userTotalBorrowed = userBorrowed[msg.sender] + amount;
        require(userCollateral[msg.sender] * 100 >=  userTotalBorrowed * MIN_COLLATERAL_RATIO, "User does not have enough collateral for this loan");
        require(amount > 0, "Must borrow more than 0 ETH");
        require(address(this).balance > amount, "Contract does not have enough funds for this loan");

        userBorrowed[msg.sender] += amount;
        totalBorrowed += amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require (success, "Loan failed");
        emit FundsBorrowed(msg.sender, amount);
    }
}