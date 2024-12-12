# ETH Lending Protocol

A proof-of-concept DeFi lending protocol built on Ethereum that demonstrates key concepts of decentralized lending. This educational project implements core lending functionality with ETH as both collateral and borrowed asset. Currently deployed on Sepolia testnet for testing and development purposes.

## Project Overview

This project serves as a practical exploration of DeFi protocol development, implementing essential lending mechanisms while focusing on security best practices and smart contract architecture.

### Core Functionality

- ETH collateral deposits and withdrawals
- Borrowing against collateral
- 150% minimum collateralization ratio
- Secure state management
- Reentrancy protection

### Technical Implementation

- Smart contract written in Solidity
- Hardhat development environment
- OpenZeppelin security contracts integration
- Sepolia testnet deployment via Alchemy

## Development Stack

```
Solidity ^0.8.0
Hardhat
OpenZeppelin Contracts
Alchemy (Sepolia Provider)
```

## Local Setup

```bash
# Install dependencies
npm install

# Configure environment
# Create .env and add required API keys (see .env.example)
```

## Contract Interface

```solidity
function deposit() external payable;
function withdraw(uint256 amount) external;
function borrowFunds(uint256 amount) external;
function repayFunds() external payable;
```

## Development Roadmap

Current focus areas:
- Interest rate mechanism implementation
- Liquidation functionality
- Health factor calculations
- Oracle price feeds integration

Future considerations:
- Multiple asset support
- Advanced risk management features
- Enhanced testing coverage

## Technical Notes

- Implements ReentrancyGuard for transaction security
- Pausable functionality for risk management
- Custom modifiers for validation:
  - validPayableAmount
  - validAmount
  - hasSufficientCollateral
  - contractHasAvailableFunds

## Contract Deployment

Currently deployed and testing on Sepolia testnet at [Contract Address]

## Learning Resources

This project draws inspiration and best practices from:
- Aave Protocol documentation
- OpenZeppelin contract standards
- Ethereum smart contract development guides

---
*This is a learning project focused on understanding DeFi protocol development and smart contract security practices.*

[Contract Address]: Add deployed contract address here
```
