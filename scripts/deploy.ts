import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  const Token = await ethers.getContractFactory("MockUSDT");
  const token = await Token.deploy();
  await token.waitForDeployment();

  const Payment = await ethers.getContractFactory("MerchantPayment");
  const payment = await Payment.deploy(await token.getAddress(), deployer.address);
  await payment.waitForDeployment();

  console.log("MockUSDT:", await token.getAddress());
  console.log("MerchantPayment:", await payment.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
