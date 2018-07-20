const TokenERC20 = artifacts.require("./TokenERC20.sol");

contract('TokenERC20 test', function(accounts) {

  it("转账测试", function() {
    let amout = web3.toWei('1','ether');
    return TokenERC20.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalanceOf.call(accounts[0]);
    }).then(function(outCoinBalanceEth) {
      var balance = web3.toBigNumber(outCoinBalanceEth);
      console.log('用户1金额：'+balance.toNumber());
      return meta.getBalanceOf.call(accounts[1]);
    }).then(function(outCoinBalanceEth) {
      console.log('用户2金额：'+outCoinBalanceEth.toString());
      return meta.transferFrom(accounts[0],accounts[1],amout,{
        from:accounts[0]
      });
    }).then(function(result){
      return meta.getBalanceOf.call(accounts[0]);
    }).then(function(admin_balance){
      var balance = web3.toBigNumber(admin_balance);
       console.log('转账后 用户1金额：'+balance.toNumber());
       return meta.getBalanceOf.call(accounts[1]);
    }).then(function(outCoinBalanceEth){
       console.log('转账后 用户2金额：'+outCoinBalanceEth.toNumber());
    });
  });
});
