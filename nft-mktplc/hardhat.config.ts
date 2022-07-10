require('dotenv').config()

import "@nomiclabs/hardhat-waffle";

import { HardhatUserConfig } from "hardhat/config"


const projectId = "OS6oMuRKI5Ck38VFbtS3mz0JlBLvw8Pk"

//console.log("MNEMONIC", process.env.MNEMONIC)

const config: HardhatUserConfig = {
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`,
      accounts: {
        mnemonic: process.env.MNEMONIC || ""
      }
    },
    mainnet: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/-Iw3tYsz9Nk42sdiklRF3rvEjl49n1JB`,
      accounts: {
        mnemonic: process.env.MNEMONIC || ""
      }
    }
  },
  solidity: "0.8.4",
};

export default config;
