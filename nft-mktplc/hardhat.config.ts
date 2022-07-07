require('dotenv').config()

import "@nomiclabs/hardhat-waffle";

import { HardhatUserConfig } from "hardhat/config"


const projectId = "OS6oMuRKI5Ck38VFbtS3mz0JlBLvw8Pk1"

//console.log("MUMBAI_MNEMONIC", process.env.MUMBAI_MNEMONIC)

const config: HardhatUserConfig = {
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`,
      accounts: {
        mnemonic: process.env.MUMBAI_MNEMONIC || ""
      }
    }
  },
  solidity: "0.8.4",
};

export default config;
