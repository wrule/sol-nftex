// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token2 is ERC20 {
  constructor() ERC20("Token2", "Token2") { }

  function mint() external {
    _mint(msg.sender, 100 * 10 ** decimals());
  }
}
