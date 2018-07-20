const Crowdsale = artifacts.require("./Crowdsale.sol");

function dealReturnStatus(result){

  for (var i = 0; i < result.logs.length; i++) {

     var log = result.logs[i];

     if (log.event == "logRecord") {

       console.log(log.args.tip);

       break;
     }

     if (log.event == "valueRecord") {

       console.log('success');

       console.log(log.args.amout);

       console.log(log.args.token);

       console.log(log.args.discountAmout);

       console.log(log.args.exchangeTokenAmout);

       break;
     }
   }
}

contract('Crowdsale test', function(accounts) {

  it("非白名单测试", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:accounts[4],
        value:web3.toWei('0.1','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

  it("白名单正确 预售时间正确 输入金额正确 代币非冻结状态", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:accounts[1],
        value:web3.toWei('2','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });


  it("不在白名单中 预售时间超过 输入金额正确 代币非冻结状态", function() {
    return Crowdsale.deployed().then(function(instance) {
      let result1 = instance.setDiscountTime(1514736000,1514822400,{
        from:accounts[0]
      })
      return instance.sendCode({
        from:accounts[2],
        value:web3.toWei('2','ether')
      });
    }).then(function(result) {
       dealReturnStatus(result);
    });
  });

  it("白名单正确 预售时间正确 输入金额最小限额测试", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:accounts[2],
        value:web3.toWei('1','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

  it("白名单正确 预售时间正确 输入金额最大限额测试", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:accounts[2],
        value:web3.toWei('5','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

it("代币冻结状态", function() {
    return Crowdsale.deployed().then(function(instance) {
      let result1 = instance.setFreezeStatus(true,{
        from:accounts[0]
      })
      return instance.sendCode({
        from:accounts[2],
        value:web3.toWei('2','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });
});
