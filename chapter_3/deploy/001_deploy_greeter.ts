import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre
    const {deploy} = deployments
    const {deployer} = await getNamedAccounts()

    await deploy ("Greeter", {
        args:["Hello world 20220702"],
        from: deployer
    })
}
export default func;