// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFT3 is ERC721Enumerable {
  constructor() ERC721("NFT3", "NFT3") ERC721Enumerable() { }

  function mint() external {
    _safeMint(msg.sender, totalSupply() + 1);
  }
}
