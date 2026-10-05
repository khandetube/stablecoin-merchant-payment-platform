# Security Notes

Implemented controls:

- AccessControl for privileged operations
- ReentrancyGuard on token-moving functions
- replay protection for payment IDs
- zero-address validation
- amount validation
- explicit ERC-20 transfer result checks
- merchant balance accounting

Before production:

- independent smart-contract audit
- threat modeling
- fuzz/property testing
- gas review
- multisig for privileged roles
- pause/emergency strategy
- production stablecoin/address allowlist
- chain-specific deployment review
