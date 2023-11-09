// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

struct Order {
  address owner;
  uint256 price;
}

contract Exchange {
  error TokenNotExist(IERC721 erc721, uint256 tokenId);
  function _checkTokenExist(IERC721 erc721, uint256 tokenId) internal view {
    if (erc721.ownerOf(tokenId) == address(0))
      revert TokenNotExist(erc721, tokenId);
  }
  modifier checkTokenExist(IERC721 erc721, uint256 tokenId) {
    _checkTokenExist(erc721, tokenId);
    _;
  }

  error Inoperable(
    address operator,
    IERC721 erc721,
    uint256 tokenId
  );
  function _checkOperable(
    address operator,
    IERC721 erc721,
    uint256 tokenId
  ) internal view checkTokenExist(erc721, tokenId) {
    address owner = erc721.ownerOf(tokenId);
    if (
      operator != owner &&
      operator != erc721.getApproved(tokenId) &&
      !erc721.isApprovedForAll(owner, operator)
    ) revert Inoperable(operator, erc721, tokenId);
  }
  modifier checkOperable(
    address operator,
    IERC721 erc721,
    uint256 tokenId
  ) {
    _checkOperable(operator, erc721, tokenId);
    _;
  }

  mapping(address => mapping(uint256 => Order)) public orders;

  function limitSell(
    IERC721 erc721,
    uint256 tokenId,
    uint256 ethPrice
  ) external
    checkOperable(msg.sender, erc721, tokenId)
    checkOperable(address(this), erc721, tokenId) {
    Order storage order = orders[address(erc721)][tokenId];
    order.owner = msg.sender;
    order.price = ethPrice;
  }

  function targetedBuy(
    IERC721 erc721,
    uint256 tokenId
  ) external payable {
    // checkOperable(address(this), erc721, tokenId);
    Order storage order = orders[address(erc721)][tokenId];
    if (msg.value < order.price) revert();
    address owner = erc721.ownerOf(tokenId);
    erc721.safeTransferFrom(owner, msg.sender, tokenId);
    (bool success1, ) = owner.call{value: order.price}("");
    if (!success1) revert();
    (bool success2, ) = msg.sender.call{value: msg.value - order.price}("");
    if (!success2) revert();
  }
}
