pragma solidity ^0.4.16;

contract token {

    function transferFrom(address _from,address _to, uint amount) public returns(bool);

    function getBalanceOf(address _address) public returns(uint);
}

contract Crowdsale {

    address public beneficiary = 0xFe8196df811986f69A5320435bf401B8a7064B0a;  // 募资成功后的收款方

    uint public price = 2;    //  token 与以太坊的汇率 , token卖多少钱

    uint public minTokenNumber = 2 * 1 ether; //最小限购数量  单位为wei

    uint public maxTokenNumber = 3 * 1 ether; //最大限购数量  单位为wei

    token public tokenReward = token(0x9123EaEc6Ea3749583949537cADf2cDB144f7f41);

    address public owner;

    uint public preSaleBeginTime = 1530374400; //预售开始时间

    uint public preSaleEndTime = 1532880000; //预售结束时间

    bool public isFreezeStatus = false; //是否冻结

    address public companyGiveTokenAddress = 0x39EcFc11af9ecD1b438fc2E2391aac801D4810AB; //公司发送代币地址

    //白名单

    address[] public whiteList = [0x5ba67A404c5eB63f3733bC1b5fB6b3B9D02f8e64,0x6fe650379c5643cBD9FE36A2cbDba852A25DDfb4];

    event logRecord(address requestAddress,string tip);

    event valueRecord(address requestAddress,uint amout,uint token,uint discountAmout,uint exchangeTokenAmout);

    /**
     * 构造函数, 设置相关属性
     */
    constructor() public {

        owner = msg.sender;
    }

    function() public payable{

      uint payEther = msg.value; //发送的以太币数量 单位为wei

      address senderAddres = msg.sender; //发送的用户钱包地址

      (uint discountAmout,bool whiteListBool) = dealWhiteList(senderAddres,payEther);

      bool tokenFreezeBool = dealTokenFreeze(); //处理用户冻结

      bool maxMinTokenBool = dealMaxAndMaxBuyNumber(payEther); //处理代币 最小 最大限额

      uint exchangeTokenAmout = discountAmout * price; // 折扣价的代币数量

      bool companyTokenLengalBool = dealCompanyTokenlengal(exchangeTokenAmout); //处理兑换token 是否主账户有、

      if(whiteListBool == false  && maxMinTokenBool == false && tokenFreezeBool == false && companyTokenLengalBool == false ){

        uint _beforeAmout = tokenReward.getBalanceOf(msg.sender);

        beneficiary.transfer(msg.value); // 给用户收ETH账号 打入以太币

        tokenReward.transferFrom(companyGiveTokenAddress,msg.sender,exchangeTokenAmout);//代币账户之间转让功能

        uint _afterAmout = tokenReward.getBalanceOf(msg.sender);

        emit valueRecord(msg.sender,_beforeAmout,_afterAmout,discountAmout,exchangeTokenAmout);

      } else{

        msg.sender.transfer(payEther); //如出现错误  将比特币还给用户
      }
    }

    //设置预售时间段 用于单元测试

    function setDiscountTime(uint beginTime,uint endTime) public {

       if(owner == msg.sender){

          preSaleBeginTime = beginTime;

          preSaleEndTime = endTime;

          emit logRecord(msg.sender,'预售时间修改成功');
       }
    }

    //用于设置是否冻结代币兑换流程

    function setFreezeStatus(bool _freezeStatus) public{

      if(owner == msg.sender){

        isFreezeStatus = _freezeStatus;

        emit logRecord(msg.sender,'冻结状态修改成功');
      }
    }

    //处理白名单 如在预售时间段内 用户钱包地址 在白名单中  用以太币计算折扣  如果当前时间不存在预售时间段中 返回用户输入的以太币

    function dealWhiteList(address _to,uint _payEther) public returns(uint,bool){

        uint discountAmout = 0;

        uint canWhiteList = 0;

        bool whiteListBool = false;

        //当前区块链时间 在 预售阶段中 判断用户是否在预售白名单中 存在 进行折扣

        if(now >= preSaleBeginTime && now <= preSaleEndTime){

          for(uint i = 0 ; i < whiteList.length; i++){

             //用户钱包地址 在白名单中存在

              if(whiteList[i] == _to){

                  canWhiteList = 1;

                  discountAmout = _payEther + (_payEther * 1 / 10); //折扣价为10%

                  break;
              }
          }

          if(canWhiteList == 0){

              emit logRecord(msg.sender,'Users are not on the white list');

              whiteListBool = true;
          }

        } else{

          discountAmout = _payEther;
        }
        return (discountAmout,whiteListBool);
    }

    //处理代币是否冻结

    function dealTokenFreeze() private returns(bool){

      bool tokenFreezeBool = false;

       if(isFreezeStatus == true){

         emit logRecord(msg.sender,'The token has been frozen and cannot be operated.');

         tokenFreezeBool = true;
       }

       return (tokenFreezeBool);
    }

    //处理公司TOKEN账户是否有足够的代币金额进行兑换

    function dealCompanyTokenlengal(uint _amout) internal returns(bool){

      bool companyTokenLengalBool = false;

      uint companyGiveTokenAmout = tokenReward.getBalanceOf(companyGiveTokenAddress);

      if(companyGiveTokenAmout <  _amout){

         emit logRecord(msg.sender,'The shortage of token');

         companyTokenLengalBool = true;
      }

       return (companyTokenLengalBool);
    }

    //处理 用购买的以太币 判断是否在可预许的购买范围中

    function dealMaxAndMaxBuyNumber(uint _payEther) private returns(bool)  {

      bool maxMinTokenBool = false;

      if(_payEther < minTokenNumber ||  _payEther > maxTokenNumber){

          emit logRecord(msg.sender,'Purchase more than the minimum, maximum limit');

          maxMinTokenBool = true;
      }

      return (maxMinTokenBool);
    }

    //发送代币  转账类型  可以接受 用户的以太币 单位为wei

    function sendCode() payable public {

      uint payEther = msg.value; //发送的以太币数量 单位为wei

      address senderAddres = msg.sender; //发送的用户钱包地址

      (uint discountAmout,bool whiteListBool) = dealWhiteList(senderAddres,payEther);

      bool tokenFreezeBool = dealTokenFreeze(); //处理用户冻结

      bool maxMinTokenBool = dealMaxAndMaxBuyNumber(payEther); //处理代币 最小 最大限额

      uint exchangeTokenAmout = discountAmout * price; // 折扣价的代币数量

      bool companyTokenLengalBool = dealCompanyTokenlengal(exchangeTokenAmout); //处理兑换token 是否主账户有、

      if(whiteListBool == false  && maxMinTokenBool == false && tokenFreezeBool == false && companyTokenLengalBool == false ){

        uint _beforeAmout = tokenReward.getBalanceOf(msg.sender);

        beneficiary.transfer(msg.value); // 给用户收ETH账号 打入以太币

        tokenReward.transferFrom(companyGiveTokenAddress,msg.sender,exchangeTokenAmout);//代币账户之间转让功能

        uint _afterAmout = tokenReward.getBalanceOf(msg.sender);

        emit valueRecord(msg.sender,_beforeAmout,_afterAmout,discountAmout,exchangeTokenAmout);

      } else{

        msg.sender.transfer(payEther); //如出现错误  将比特币还给用户
      }
    }
}
