const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Reentrancy NFT Contract Tests", function () {
    let owner, nftContract, attackerContract;
    const init_eth = ethers.parseEther("1")
    beforeEach(async function () {
        [owner, attacker] = await ethers.getSigners();

        const nftFac = await ethers.getContractFactory("NFT");
        nftContract = await nftFac.deploy();

        const attackFac = await ethers.getContractFactory("Attacker");
        attackerContract = await attackFac.deploy(nftContract.target);

        // await attacker.sendTransaction({
        //     to: attackerContract.target,
        //     value: ethers.parseUnits("1", "ether")
        // });
    });

    describe("Read-only reentrancy Attack", function () {
        it("Should attack success", async function () {
            await attackerContract.connect(attacker).attack({  
                value: init_eth,
            })
            
            const mintedNFT = await nftContract.balanceOf(attackerContract.target)
            const expectedmintedNFT = 5; 

            expect(mintedNFT).to.equal(expectedmintedNFT);
        });
    });
});
