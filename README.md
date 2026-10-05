# Stablecoin Merchant Payment Platform

A portfolio-grade Web3 payment and merchant settlement MVP designed around an EVM stablecoin payment flow.

## Scope

- ERC-20 stablecoin payment processing
- Merchant registration and settlement accounting
- On-chain payment events and transaction tracking
- Solidity smart-contract architecture with role-based access control
- Hardhat-based testing
- TypeScript/Node.js integration layer
- React/Next.js-ready frontend architecture
- Wallet integration target: MetaMask / WalletConnect
- Security-focused design and test coverage

## Payment lifecycle

1. Merchant is registered.
2. Customer connects an EVM wallet.
3. Customer approves the payment token.
4. Customer pays the merchant through the payment contract.
5. Contract emits a payment event.
6. Backend/indexer records the transaction.
7. Merchant can request settlement according to configured rules.

## Repository structure

```
contracts/   Solidity contracts
test/        Contract tests
scripts/     Deployment and utility scripts
backend/     TypeScript service layer
frontend/    Frontend application scaffold
docs/        Architecture and security documentation
```

## Status

This repository is an independently built portfolio project. It is intentionally separate from all previous portfolio repositories.

> Testnet/demo software only. Do not use with production funds without an independent security audit.
