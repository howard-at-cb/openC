import {ethers} from "hardhat"
import {expect} from "chai"
import { BalanceReader, BalanceReader__factory } from "../typechain"

import { Signer } from "ethers";

const USDC_MAINNET_ADDRESS = "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48";
const ALAMEDA_ADDRESS = "0x0F4ee9631f4be0a63756515141281A3E2B293Bbe";
const USDC_DECIMALS = 6

describe("BalanceReader tests", () => {
    let instance: BalanceReader
    let accounts: Signer[]
    let defaultSigner: Signer

    beforeEach(async() => {
        accounts = await ethers.getSigners()
        defaultSigner = accounts[0]

        const factory = new BalanceReader__factory(defaultSigner)
        instance = await factory.deploy()
    })

    it ('should get the Alameda balance', async () => {
        const balance = await instance.getERC20BalanceOf(ALAMEDA_ADDRESS, USDC_MAINNET_ADDRESS)
        console.log("Balance", balance)

        const balanceAsString = ethers.utils.formatUnits(balance, USDC_DECIMALS);
        console.log("Balance as string", balanceAsString)
    })
})