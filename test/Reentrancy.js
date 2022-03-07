const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Reentrancy tests", function () {
  let TokenStore, Reentrancy;
  let storeInstance, reentrancy;
  let owner, accounts;

  this.beforeEach(async function () {
    [owner, ...accounts] = await ethers.getSigners();

    TokenStore = await ethers.getContractFactory("TokenStore");
    storeInstance = await TokenStore.deploy();
    await storeInstance.deployed();

    Reentrancy = await ethers.getContractFactory("Reentrancy");
    reentrancy = await Reentrancy.deploy(storeInstance.address);
    await reentrancy.deployed();
  });

  xit("Deployment: Initial balance must be 0", async function () {

    expect(await reentrancy.getThisBalance()).to.equal(0);
  });

  xit("TokenStore: Deposit an amount successfully", async function () {
    await storeInstance.connect(accounts[0])
      .deposit({ value: 1000 });
    // await storeInstance.connect(accounts[0])
    //   .deposit({ value: ethers.utils.parseEther("1.0") });

    await storeInstance.connect(accounts[1])
      .deposit({ value: 2000 });

    const storeBalance = await storeInstance.getThisBalance();
    expect(storeBalance).to.equal(3000);
    const balance0 = parseInt(await storeInstance.getAccountBalance(accounts[0].address));
    expect(balance0).to.equal(1000);
    const balance1 = parseInt(await storeInstance.getAccountBalance(accounts[1].address));
    expect(balance1).to.equal(2000);
  });

  it("Reentrancy attack", async function () {
    storeInstance.connect(accounts[1]).deposit({value: ethers.utils.parseEther("1.0")});
    storeInstance.connect(accounts[2]).deposit({value: ethers.utils.parseEther("1.0")});

    console.log('Before:');
    console.log(await reentrancy.getThisBalance());
    console.log(await storeInstance.getThisBalance(), "\n");
    await reentrancy.attack({value: ethers.utils.parseEther("1.0")});
    console.log('After:');
    console.log(await reentrancy.getThisBalance());
    console.log(await storeInstance.getThisBalance());
  });
});
