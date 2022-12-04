require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    goerli: {
      url: process.env.GOERLI,
      accounts: [process.env.PVT_KEY ? process.env.PVT_KEY : ""],
    },
    mumbai: {
      url: process.env.POLY_TEST,
      accounts: [process.env.PVT_KEY ? process.env.PVT_KEY : ""],
    },
  },
};
