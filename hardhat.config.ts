import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";

const secret = require('./.secret');

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    goerli: {
      url: secret.alchemy.goerli.url,
      accounts: secret.privateKey,
    },
    sepolia: {
      url: secret.alchemy.sepolia.url,
      accounts: secret.privateKey,
    },
  },
  etherscan: secret.etherscan,
};

export default config;
