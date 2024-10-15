import pkg from 'hardhat';
const {ethers} = pkg;
async function main() {

    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    const bankFac = await ethers.getContractFactory("Bank")
    const bankConsumerFac = await ethers.getContractFactory("BankConsumer")
    const attackerFac = await ethers.getContractFactory("Attacker")

    const bankContract = await bankFac.deploy();
    await bankContract.waitForDeployment();
    const bankConsumerContract = await bankConsumerFac.deploy(bankContract.target);
    await bankConsumerContract.waitForDeployment()
    const attackerContract = await attackerFac.deploy(bankContract.target, bankConsumerContract.target);
    await attackerContract.waitForDeployment();

    console.log("Contract bank deployed at:", bankContract.target);
    console.log("Contract bank consumer deployed at:", bankConsumerContract.target);
    console.log("Contract attacker deployed at:", attackerContract.target);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

