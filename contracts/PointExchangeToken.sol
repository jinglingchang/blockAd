pragma solidity ^0.4.16;

contract token {

    function transferFrom(address _from,address _to, uint amount) public returns(bool);

    function getBalanceOf(address _address) public returns(uint);
}

contract PointExchangeToken {

    token public tokenReward = token(0x9123EaEc6Ea3749583949537cADf2cDB144f7f41);

    uint public pointProportion = 2; //1token = 2point

    address public owner;

    address public companyGiveTokenAddress = 0x39EcFc11af9ecD1b438fc2E2391aac801D4810AB; //公司发送代币地址

    event noticeUser(uint code,string tip);

    /**
     * 构造函数, 设置相关属性
     */
    constructor() public {

        owner = msg.sender;
    }

    //积分兑换

    function pointExchange(address userAddress,uint userPoint,uint _token) public{

        //将用户 填写的TOKEN数量 转换成积分数 判断用户积分是否足够

        uint pointCostNumber = _token * pointProportion;

        if(pointCostNumber <= userPoint){

          //将token 转换成与代币小数点一样的格式

          uint addTokenNumber = _token * 1 ether;

          tokenReward.transferFrom(companyGiveTokenAddress,userAddress,addTokenNumber);

          emit noticeUser(200,'操作成功');

        } else{

          emit noticeUser(500,'用户积分不足');
        }
    }
}
