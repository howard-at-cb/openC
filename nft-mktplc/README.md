# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

for typescript
```shell
npm install --save-dev ts-node
npm install dotenv -D
npm install typechain@8.1.0 @typechain/hardhat @typechain/ethers-v5 -D 
npm i --save-dev @types/mocha

yarn add --dev @types/react
yarn add --dev typescript
```

for deployment 
```shell
npx hardhat node
npx hardhat run scripts/001_deploy_nft_nftmktplc.ts --network localhost
```

for front end
```shell
npm install --save-dev ipfs-http-client@50.1.2
npm run dev
```
