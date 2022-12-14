// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const AddressPool = await ethers.getContractFactory("AddressPool");
  AddressPoolInstance = await AddressPool.deploy();
  await AddressPoolInstance.deployed();

  const Builder = await ethers.getContractFactory("Builder");
  BuilderInstance = await Builder.deploy(AddressPoolInstance.address);
  await BuilderInstance.deployed();

  const EREIT = await ethers.getContractFactory("EREIT");
  EREITInstance = await EREIT.deploy(AddressPoolInstance.address);
  await EREITInstance.deployed();

  const EREITGoverance = await ethers.getContractFactory("EREITGoverance");
  EREITGoveranceInstance = await EREITGoverance.deploy(
    AddressPoolInstance.address
  );
  await EREITGoveranceInstance.deployed();

  await AddressPoolInstance.setBuilderAddress(BuilderInstance.address);
  await AddressPoolInstance.setEreitTokenAddress(EREITInstance.address);
  await AddressPoolInstance.setEreitGovernanceAddress(
    EREITGoveranceInstance.address
  );

  console.log(`Address Pool deployed at ${AddressPoolInstance.address}`);
  console.log(`Builder deployed at ${BuilderInstance.address}`);
  console.log(`EREIT deployed at ${EREITInstance.address}`);
  console.log(`EREIT Goverance deployed at ${EREITGoveranceInstance.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
