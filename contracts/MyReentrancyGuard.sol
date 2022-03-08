//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

abstract contract MyReentrancyGuard {

  bool private _locked ;

  constructor() {
    _locked = false;
  }

  modifier nonReentrant() {
    console.log("_locked ==", _locked);
    require(!_locked , "ReentrancyGuard: locked!");

    _locked = true;

    _;

    _locked = false;
  }
}