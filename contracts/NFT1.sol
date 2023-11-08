// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFT1 is ERC721Enumerable {
  constructor() ERC721("NFT1", "NFT1") ERC721Enumerable() { }
}
