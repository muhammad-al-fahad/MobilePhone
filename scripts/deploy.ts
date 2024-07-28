import { ethers } from "hardhat";

async function main() {
    const contract = await ethers.getContractFactory("MobilePhones")
    const deployedContract = await contract.deploy()
    console.log("Deployed contract address: ", deployedContract.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })