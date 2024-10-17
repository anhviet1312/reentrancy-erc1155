const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Reentrancy NFT Contract Tests", function () {
    let owner, nftContract, attackerContract, nftLendingContract;
    beforeEach(async function () {
        [owner, attacker] = await ethers.getSigners();

        const nftFac = await ethers.getContractFactory("NFT1");
        nftContract = await nftFac.deploy();


        const nftLendingFac = await ethers.getContractFactory("VulnerableNFTLending");
        nftLendingContract = await nftLendingFac.deploy(nftContract.target);

        const attackFac = await ethers.getContractFactory("Attacker1");
        attackerContract = await attackFac.deploy(nftLendingContract.target, nftContract.target);

        await owner.sendTransaction({
            to: nftLendingContract.target,
            value: ethers.parseUnits("20", "gwei")
        });
    });

    describe("Reentrancy Attack", function () {
        it("Should attack success", async function () {
            // await nftContract.mint(attackerContract.target, 1);

            // const ownerOf = await nftContract.ownerOf(1);
            // expect(ownerOf).to.equal(attackerContract.target);
          //  expect(nftContract.target).to.equal("232")
        //     expect(attacker.address).to.equal("232")
           //  expect(attackerContract.target).to.equal("232")
           // expect(nftLendingContract.target).to.equal("1")
            const loanAmount = ethers.parseUnits("1", "gwei");
            await attackerContract.connect(attacker).attack(1, loanAmount);

        });
    });
});
