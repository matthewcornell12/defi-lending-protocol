// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract LendingPool is ReentrancyGuard, Pausable {
    // Constants
    uint256 constant MIN_COLLATERAL_RATIO = 150; // 150% collateralization required

    // State Variables
    mapping(address => uint256) public userCollateral;
    uint256 public totalCollateral;

    mapping(address => uint256) public userBorrowed;
    uint256 public totalBorrowed;

    // Event definitions
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    event FundsBorrowed(address indexed user, uint256 amount);
    event FundsRepaid(address indexed user, uint256 amount, uint256 balanceRemaining);

    // Function definitions
    function deposit() public payable validPayableAmount nonReentrant {
        userCollateral[msg.sender] += msg.value;
        totalCollateral += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdrawal(uint256 amount) public hasSufficientCollateral(amount) nonReentrant {
        totalCollateral -= amount;
        userCollateral[msg.sender] -= amount;

        (bool success, ) = msg.sender.call{ value: amount }("");
        require(success, "Withdrawal Failed");
        emit Withdrawal(msg.sender, amount);
    }

    function borrowFunds(
        uint256 amount
    ) public validAmount(amount) contractHasAvailableFunds(amount) nonReentrant {
        uint256 userTotalBorrowed = userBorrowed[msg.sender] + amount;
        require(
            userCollateral[msg.sender] * 100 >= userTotalBorrowed * MIN_COLLATERAL_RATIO,
            "User does not have enough collateral for this loan"
        );

        userBorrowed[msg.sender] += amount;
        totalBorrowed += amount;

        (bool success, ) = msg.sender.call{ value: amount }("");
        require(success, "Loan failed");
        emit FundsBorrowed(msg.sender, amount);
    }

    function repayFunds() public payable validPayableAmount nonReentrant {
        require(msg.value <= userBorrowed[msg.sender], "Cannot repay more than owed");

        userBorrowed[msg.sender] -= msg.value;
        totalBorrowed -= msg.value;

        emit FundsRepaid(msg.sender, msg.value, userBorrowed[msg.sender]);
    }

    modifier validPayableAmount() {
        require(msg.value > 0, "Transaction must have more than 0 ETH");
        _;
    }

    modifier validAmount(uint256 amount) {
        require(amount > 0, "Argument amount must be more than 0 ETH");
        _;
    }

    modifier hasSufficientCollateral(uint256 amount) {
        require(
            userCollateral[msg.sender] >= amount,
            "User does not have enough collateral for withdrawal"
        );
        _;
    }

    modifier contractHasAvailableFunds(uint256 amount) {
        require(address(this).balance >= amount, "Contract does not have enough funds");
        _;
    }
}
