// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract LendingPool is ReentrancyGuard, Pausable {
    // State Variables
    mapping (address => uint256) public userCollateral;
    uint256 public totalCollateral;

    mapping (address => uint256) public userBorrowed;
    uint256 public totalBorrowed;


    // Event definitions
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

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
}