import {ethers} from "hardhat";

async function main(){

    const bet = ethers.utils.parseEther("0.00001");

    // const CoinFlip = await ethers.getContractFactory("CoinFlip");
    // const coinFlip = await CoinFlip.deploy();

    // await coinFlip.deployed();
    // console.log (`coin flip cotract address is: ${coinFlip.address}`);

    const connect = await ethers.getContractAt( "CoinFlip", "0x5FbDB2315678afecb367f032d93F642f64180aa3");

    // const play = await coinFlip.flip(0, {value: bet}); 
    const play = await connect.flip(0, {value: bet}); 
    console.log(await (await play.wait()).events);
}
main().catch((error) =>{
    console.error(error);
    process.exitCode = 1;
})