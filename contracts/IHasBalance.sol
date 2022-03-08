//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract IHasBalance {
  function getThisBalance() public view returns (uint256) {
    return address(this).balance;
  }
}