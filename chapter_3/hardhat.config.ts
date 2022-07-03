require('dotenv').config()

import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat"
import "@nomiclabs/hardhat-ethers"

import { HardhatUserConfig } from "hardhat/config"

console.log("MAINNET_FORKING_URL", process.env.MAINNET_FORKING_URL)

const config: HardhatUserConfig = {
    solidity: {
        version: "0.8.4"
    },
    typechain: {
        outDir: "typechain"
    },
    networks: {
        hardhat: {
            forking: {
                url: process.env.MAINNET_FORKING_URL || ""
            }
        }
    }
}

export default config;