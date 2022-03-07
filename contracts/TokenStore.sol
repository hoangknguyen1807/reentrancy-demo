//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./IReceiver.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TokenStore is IReceiver {
  mapping(address => uint256) private _balances;

  function deposit() external payable {
    require(msg.value > 0, "Deposit amount must be > 0");
    _balances[msg.sender] += msg.value;
  }

  function withdraw(uint256 _amount) external payable {
    require(_balances[msg.sender] >= _amount);

    console.log("Store balance before:", getThisBalance() / 10**18);
    console.log("Caller balance before:", msg.sender.balance / 10**18);
    
    (bool sent,) = msg.sender.call{value: _amount}("");

    if (!sent) {
      console.log("*** sent == false ***");
      console.log(getThisBalance() / 10**18);
      console.log(_balances[msg.sender] / 10**18);
    }
    require(sent, "Sending ether failed!");

    console.log("Caller balance before subtract:", _balances[msg.sender] / 10**18);
    _balances[msg.sender] -= _amount;
    console.log("Caller balance after subtract:", _balances[msg.sender] / 10**18, "\n\n");
  }

  function getAccountBalance(address _account) public view returns (uint256) {
    return _balances[_account];
  }

  function getAddressBalance(address addr) public view returns (uint256) {
    return addr.balance;
  }
}