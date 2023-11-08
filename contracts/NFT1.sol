// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT1 is ERC721 {
  constructor() ERC721("NFT1", "NFT1") { }
}
