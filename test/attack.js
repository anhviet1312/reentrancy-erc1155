const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Reentrancy NFT Contract Tests", function () {
    let owner, nftContract, attackerContract;
    const ether1 = ethers.parseUnits("1", "ether");
    beforeEach(async function () {
        [owner, attacker] = await ethers.getSigners();

        const nftFac = await ethers.getContractFactory("VulnerableVault");
        nftContract = await nftFac.deploy();

        const attackFac = await ethers.getContractFactory("Attacker");
        attackerContract = await attackFac.deploy(nftContract.target);

        await attacker.sendTransaction({
            to: attackerContract.target,
            value: ether1
        });

        await owner.sendTransaction({
            to: nftContract.target,
            value: ethers.parseUnits("15", "ether")
        });
    });

    describe("Reentrancy Attack", function () {
        it("Should attack success", async function () {
            await attackerContract.connect(attacker).attack()
            
            const currentBalanceToken1 = await nftContract.balanceOf(attackerContract.target, 1);
            const currentBalanceToken2 = await nftContract.balanceOf(attackerContract.target, 2);
            const depositAmountToken2 = await nftContract.records(2);
           
            expect(currentBalanceToken1).to.equal(1);
            expect(currentBalanceToken2).to.equal(11);
            expect(depositAmountToken2).to.equal(ether1);
        });
    });
});
