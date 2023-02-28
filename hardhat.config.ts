import * as dotenv from "dotenv";
dotenv.config();
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "hardhat-abi-exporter";
const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 99999,
          },
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 99999,
          },
        },
      },
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 99999,
          },
        },
      },
    ],
  },
  networks: {
    hardhat: {
      // allowUnlimitedContractSize: true,
    },

    localhost: {
      url: "http://localhost:8545",
      accounts: [process.env.PRIVATE_KEY_localhost!],
    },
    goerli: {
      url: "https://goerli.infura.io/v3/f4dd6db18a6f4ea98151892c0fa8e074",
      accounts: [process.env.PRIVATE_KEY_goerli!],
    },
    polygon: {
      url: "https://rpc-mainnet.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY_POLYGON!],
    },
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  abiExporter: {
    path: "../idea3-frontend/abi",
    runOnCompile: true,
    clear: true,
    flat: false,
    spacing: 2,
    format: "json",
  },
  typechain: {
    outDir: "../idea3-frontend/types",
    target: "ethers-v5",
  },
};

export default config;
