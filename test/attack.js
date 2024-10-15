const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Reentrancy NFT Contract Tests", function () {
    let owner, nftContract, attackerContract;
    const default_price = ethers.parseUnits("2" , "gwei")
    beforeEach(async function () {
        [owner, attacker] = await ethers.getSigners();

        const nftFac = await ethers.getContractFactory("NFT");
        nftContract = await nftFac.deploy();

        const attackFac = await ethers.getContractFactory("Attacker");
        attackerContract = await attackFac.deploy(nftContract.target);
    });

    describe("Read-only reentrancy Attack", function () {
        it("Should attack success", async function () {
            await attackerContract.connect(attacker).attack({  
                value: default_price,
            })
            
            const mintedNFT = await nftContract.balanceOf(attackerContract.target)
            const expectedmintedNFT = 2; 

            expect(mintedNFT).to.equal(expectedmintedNFT);
        });
    });
});
