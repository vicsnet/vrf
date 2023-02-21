import {ethers} from "hardhat";
async function main(){
const  GenerateRand = await ethers.getContractFactory("GenerateRandNo");
const generateRand = await GenerateRand.deploy();
await generateRand.deployed();
console.log(`Generate Random number Contract Address is: ${generateRand.address}`);

// const requestRandNo = await generateRand.requestRandomWords();

// console.log(requestRandNo);

// 0x5FbDB2315678afecb367f032d93F642f64180aa3
}
main().catch((error)=>{
    console.error(error);
    process.exitCode = 1;
})
