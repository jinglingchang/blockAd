var TokenERC20 = artifacts.require("./TokenERC20.sol");
module.exports = function(deployer) {
  deployer.deploy(TokenERC20,{
    from:web3.eth.accounts[0]
  });
};
