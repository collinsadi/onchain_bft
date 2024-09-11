const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("OnChainNFTModule", (m) => {
  const onchainNFT = m.contract("OnChainNFT");

  return { onchainNFT };
});
