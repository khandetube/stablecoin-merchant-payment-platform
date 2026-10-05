# Architecture

Customer Wallet
      |
      v
React / Next.js
      |
      v
MerchantPayment.sol <---- ERC-20 Stablecoin
      |
      +---- PaymentReceived events
      |
      v
TypeScript backend / indexer
      |
      v
Merchant dashboard / settlement operations

## Security boundaries

The browser never receives or asks for a seed phrase. Contract operators are role-protected. Payment IDs provide replay protection. ERC-20 transfers are checked for success. Settlement is restricted to the operator role and cannot exceed the merchant's recorded balance.
