require('dotenv').config()

import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat"
import "@nomiclabs/hardhat-ethers"
import "hardhat-deploy"

import { HardhatUserConfig } from "hardhat/config"

console.log("MAINNET_FORKING_URL", process.env.MAINNET_FORKING_URL)
console.log("Goerli_URL", process.env.GOERLI_URL)

const config: HardhatUserConfig = {
    solidity: {
        version: "0.8.4"
    },
    typechain: {
        outDir: "typechain"
    },
    namedAccounts : {
        deployer: 0
    },
    networks: {
        hardhat: {
            forking: {
                url: process.env.MAINNET_FORKING_URL || ""
            }
        },
        goerli: {
            url: process.env.GOERLI_URL || "",
            accounts: {
                mnemonic: process.env.GOERLI_MNEMONIC || ""
            }
        }
    }
}

export default config;