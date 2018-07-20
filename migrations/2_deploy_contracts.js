var Crowdsale = artifacts.require("./Crowdsale.sol");
module.exports = function(deployer) {
  deployer.deploy(Crowdsale,{
    from:'0x39EcFc11af9ecD1b438fc2E2391aac801D4810AB'
  });
};
