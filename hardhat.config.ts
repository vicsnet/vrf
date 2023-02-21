import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks:{

    mumbai:{
       url: "https://eth-mainnet.g.alchemy.com/v2/7KPCNan56WStQo-fHWWtuuX9qIXxRGio",
       accounts:[
         'a495703354cff429858008a639852747da03d8a59e6822a846a635325848f489',
       ]
     }
  },
  etherscan:{
    apiKey: "7KPCNan56WStQo-fHWWtuuX9qIXxRGio",
  },
};

export default config;
