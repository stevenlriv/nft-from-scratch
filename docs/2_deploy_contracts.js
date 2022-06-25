const SmartContractName = "EnterContractNameHere";

const SmartContract = artifacts.require(SmartContractName);

module.exports = function (deployer) {
  deployer.deploy(SmartContract);
};