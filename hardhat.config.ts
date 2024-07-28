import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as env from 'dotenv';
env.config();

const {API_KEY, PRIVATE_KEY} = process.env;
const config: HardhatUserConfig = {
  solidity: "0.8.26",
  defaultNetwork: "sepolia",
  networks: {
    sepolia: {
      url: API_KEY,
      accounts: [PRIVATE_KEY || ""]
    }
  }
};

export default config;
