// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MerchantPayment is AccessControl, ReentrancyGuard {
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    struct Merchant {
        bool active;
        address settlementAddress;
        uint256 balance;
    }

    IERC20 public immutable paymentToken;
    mapping(bytes32 => Merchant) public merchants;
    mapping(bytes32 => bool) public processedPayments;

    event MerchantRegistered(bytes32 indexed merchantId, address indexed settlementAddress);
    event PaymentReceived(
        bytes32 indexed paymentId,
        bytes32 indexed merchantId,
        address indexed payer,
        uint256 amount
    );
    event Settlement(bytes32 indexed merchantId, address indexed recipient, uint256 amount);

    constructor(address token, address admin) {
        paymentToken = IERC20(token);
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(OPERATOR_ROLE, admin);
    }

    function registerMerchant(bytes32 merchantId, address settlementAddress)
        external
        onlyRole(OPERATOR_ROLE)
    {
        require(merchantId != bytes32(0), "invalid merchant");
        require(settlementAddress != address(0), "invalid settlement");
        merchants[merchantId] = Merchant(true, settlementAddress, 0);
        emit MerchantRegistered(merchantId, settlementAddress);
    }

    function pay(bytes32 paymentId, bytes32 merchantId, uint256 amount)
        external
        nonReentrant
    {
        require(!processedPayments[paymentId], "payment already processed");
        Merchant storage merchant = merchants[merchantId];
        require(merchant.active, "merchant inactive");
        require(amount > 0, "amount is zero");

        processedPayments[paymentId] = true;
        require(
            paymentToken.transferFrom(msg.sender, address(this), amount),
            "transfer failed"
        );

        merchant.balance += amount;
        emit PaymentReceived(paymentId, merchantId, msg.sender, amount);
    }

    function settle(bytes32 merchantId, uint256 amount)
        external
        onlyRole(OPERATOR_ROLE)
        nonReentrant
    {
        Merchant storage merchant = merchants[merchantId];
        require(merchant.active, "merchant inactive");
        require(amount > 0 && amount <= merchant.balance, "invalid amount");

        merchant.balance -= amount;
        require(paymentToken.transfer(merchant.settlementAddress, amount), "transfer failed");
        emit Settlement(merchantId, merchant.settlementAddress, amount);
    }

    function setMerchantStatus(bytes32 merchantId, bool active)
        external
        onlyRole(OPERATOR_ROLE)
    {
        require(merchants[merchantId].settlementAddress != address(0), "unknown merchant");
        merchants[merchantId].active = active;
    }
}
