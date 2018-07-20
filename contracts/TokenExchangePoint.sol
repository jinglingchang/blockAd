pragma solidity ^0.4.11;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract token {

    function transferFrom(address _from,address _to, uint amount) public returns(bool);

    function getBalanceOf(address _address) public returns(uint);
}

contract TokenExchangePoint is usingOraclize {

    event logResult(uint code);

    event logStatus(string _string);

    uint tokenAmout = 0;

    token public tokenReward = token(0x4c0afd393FaA8738E88654C4DB88C9C9A9C312c2);

    address public companyGiveTokenAddress = 0x4D51aCC14035b49A78Ae73e0d3A80bCC936B768b; //公司发送代币地址

    constructor() payable{

        //部署合约时 给合约地址 转账以太币 用于调用外部API接口

        if(msg.value > 0){

          address(this).transfer(msg.value);
        }
    }

    function sendScore(uint amout) public{

      //将代币转换成小数点形势

      tokenAmout = amout * 1 ether;

      if(tokenAmout > 0){

          uint userToken = tokenReward.getBalanceOf(msg.sender);

          if(userToken >= amout){

            if (oraclize_getPrice("URL") > this.balance) {
                logStatus("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
            } else {
                tokenReward.transferFrom(msg.sender,companyGiveTokenAddress,tokenAmout);
                logStatus("Oraclize query was sent, standing by for the answer..");
                oraclize_query("URL", "json(http://sjff.sdhasia.com/WebShopNews/add_news_number?news_id=4062).code");
            }

          } else{

             emit logStatus('用户代币不足');
          }
       }
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        logStatus(result);
    }
}
