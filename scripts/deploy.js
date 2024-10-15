import pkg from 'hardhat';
const {ethers} = pkg;
async function main() {

    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // const bankFac = await ethers.getContractFactory("Bank");
    // const bankContract = await bankFac.deploy();
    // await bankContract.waitForDeployment();
    // console.log("Contract vulnerable deployed at:", bankContract.address);

    // const bankConsumerFac = await ethers.getContractFactory("BankConsumer");
    // const bankConsumer = await bankConsumerFac.deploy("0xA6009AC8640458F4B7C9553DC01f98eD0E454Ac3");
    // await bankConsumer.waitForDeployment();
    // console.log("Contract vulnerable deployed at:", bankConsumer.target);

    const attackerFac = await ethers.getContractFactory("Attacker");
    const attacker = await attackerFac.deploy("0xA6009AC8640458F4B7C9553DC01f98eD0E454Ac3", "0x2C44C20baAF04752C10E4Ff7a567978323c48cDa");
    await attacker.waitForDeployment();
    console.log("Contract vulnerable deployed at:", attacker.target);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

