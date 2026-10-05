import { expect } from "chai";
import { ethers } from "hardhat";

describe("MerchantPayment", function () {
  async function fixture() {
    const [admin, customer, merchantWallet] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("MockUSDT");
    const token = await Token.deploy();

    const Payment = await ethers.getContractFactory("MerchantPayment");
    const payment = await Payment.deploy(await token.getAddress(), admin.address);

    const merchantId = ethers.id("merchant-001");
    await payment.registerMerchant(merchantId, merchantWallet.address);

    return { admin, customer, merchantWallet, token, payment, merchantId };
  }

  it("accepts an ERC-20 payment and records merchant balance", async function () {
    const { customer, token, payment, merchantId } = await fixture();
    const amount = ethers.parseEther("100");

    await token.transfer(customer.address, amount);
    await token.connect(customer).approve(await payment.getAddress(), amount);

    const paymentId = ethers.id("payment-001");
    await payment.connect(customer).pay(paymentId, merchantId, amount);

    const merchant = await payment.merchants(merchantId);
    expect(merchant.balance).to.equal(amount);
  });

  it("prevents payment replay", async function () {
    const { customer, token, payment, merchantId } = await fixture();
    const amount = ethers.parseEther("10");

    await token.transfer(customer.address, amount * 2n);
    await token.connect(customer).approve(await payment.getAddress(), amount * 2n);

    const paymentId = ethers.id("payment-replay");
    await payment.connect(customer).pay(paymentId, merchantId, amount);

    await expect(
      payment.connect(customer).pay(paymentId, merchantId, amount)
    ).to.be.revertedWith("payment already processed");
  });

  it("settles merchant funds to the configured settlement address", async function () {
    const { admin, customer, merchantWallet, token, payment, merchantId } = await fixture();
    const amount = ethers.parseEther("25");

    await token.transfer(customer.address, amount);
    await token.connect(customer).approve(await payment.getAddress(), amount);
    await payment.connect(customer).pay(ethers.id("payment-settle"), merchantId, amount);

    const before = await token.balanceOf(merchantWallet.address);
    await payment.connect(admin).settle(merchantId, amount);
    const after = await token.balanceOf(merchantWallet.address);

    expect(after - before).to.equal(amount);
  });
});
