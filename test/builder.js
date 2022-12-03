const chai = require("chai");
const { ethers, config, network } = require("hardhat");

const { expect, assert } = chai;

describe("Test Builder", () => {
  let accounts = [];
  let BuilderInstance;
  let AddressPoolInstance;
  let EREITInstance;
  let EREITGoveranceInstance;
  beforeEach(async () => {
    accounts = await ethers.getSigners();
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

    await expect(AddressPoolInstance.setBuilderAddress(BuilderInstance.address))
      .to.eventually.be.fulfilled;
    await expect(
      AddressPoolInstance.setEreitTokenAddress(EREITInstance.address)
    ).to.eventually.be.fulfilled;
    await expect(
      AddressPoolInstance.setEreitGovernanceAddress(
        EREITGoveranceInstance.address
      )
    ).to.eventually.be.fulfilled;

    await expect(EREITGoveranceInstance.mint(accounts[0].address, 100)).to
      .eventually.be.fulfilled;

    await expect(EREITGoveranceInstance.mint(accounts[1].address, 1000)).to
      .eventually.be.fulfilled;
  });

  const getSigner = async (index) => {
    return new Promise((resolve, reject) => {
      try {
        const accounts = config.networks.hardhat.accounts;
        resolve(
          ethers.Wallet.fromMnemonic(
            accounts.mnemonic,
            accounts.path + `/${index}`
          )
        );
      } catch (err) {
        reject(err.message);
      }
    });
  };

  it("deployment", async () => {
    await expect(BuilderInstance.addBuilder("Name", "GST", "url")).to.eventually
      .be.fulfilled;

    await expect(
      BuilderInstance.createProject([
        "12-03-12",
        "12-45-45",
        1000,
        "pros_url",
        ["1.2.3", "2.3.33"],
        accounts[1].address,
      ])
    ).to.eventually.be.fulfilled;

    const projects = await BuilderInstance.getAllProjectsByAddress(
      accounts[0].address
    );
    const eStateProject = await ethers.getContractFactory("eStateProject");
    const eStateInstance = await eStateProject.attach(projects[0]);

    // user give approve contract to tranfer
    await expect(EREITInstance.approve(eStateInstance.address, 100)).to
      .eventually.be.fulfilled;
    await expect(eStateInstance.invest(100)).to.eventually.be.fulfilled;
    const balance = await EREITInstance.balanceOf(eStateInstance.address);
    assert(balance == 100);
    await expect(eStateInstance.withdrawInvestment(50)).to.eventually.be
      .fulfilled;

    await expect(
      EREITInstance.connect(accounts[1]).approve(eStateInstance.address, 100)
    ).to.eventually.be.fulfilled;
    await expect(eStateInstance.connect(accounts[1]).invest(100)).to.eventually
      .be.fulfilled;

    await expect(
      EREITInstance.connect(accounts[1]).approve(eStateInstance.address, 100)
    ).to.eventually.be.fulfilled;
    await expect(eStateInstance.connect(accounts[1]).payRent(100)).to.eventually
      .be.fulfilled;

    const getInvested = await eStateInstance.getInvestedAmountInCycle(
      accounts[0].address,
      1
    );
    assert(getInvested == 50);

    await expect(eStateInstance.connect(accounts[1]).claimRentRewards()).to
      .eventually.be.fulfilled;
    await expect(eStateInstance.claimRentRewards()).to.eventually.be.fulfilled;
  });
});
