// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Exchange {
  error TokenNotExist(IERC721 erc721, uint256 tokenId);
  function checkTokenExist(IERC721 erc721, uint256 tokenId) public view {
    if (erc721.ownerOf(tokenId) == address(0))
      revert TokenNotExist(erc721, tokenId);
  }

  error Inoperable(
    address operator,
    IERC721 erc721,
    uint256 tokenId
  );
  function checkOperable(
    address operator,
    IERC721 erc721,
    uint256 tokenId
  ) public view {
    checkTokenExist(erc721, tokenId);
    address owner = erc721.ownerOf(tokenId);
    if (
      operator != owner &&
      operator != erc721.getApproved(tokenId) &&
      !erc721.isApprovedForAll(owner, operator)
    ) revert Inoperable(operator, erc721, tokenId);
  }

  function limitSell(
    IERC721 erc721,
    uint256 tokenId,
    uint256 ethAmount
  ) external {
    checkOperable(address(this), erc721, tokenId);
  }

  function targetedBuy(
    address tokenAddress,
    uint256 tokenId
  ) external {

  }
}