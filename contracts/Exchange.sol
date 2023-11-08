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

  mapping(address => mapping(uint256 => Order)) orders;

  function limitSell(
    IERC721 erc721,
    uint256 tokenId,
    uint256 ethPrice
  ) external {
    checkOperable(address(this), erc721, tokenId);
    Order storage order = orders[address(erc721)][tokenId];
    order.owner = erc721.ownerOf(tokenId);
    order.price = ethPrice;
  }

  function targetedBuy(
    IERC721 erc721,
    uint256 tokenId
  ) external payable {
    checkOperable(address(this), erc721, tokenId);
    Order storage order = orders[address(erc721)][tokenId];
    if (msg.value < order.price) {

    }
    address owner = erc721.ownerOf(tokenId);
    erc721.safeTransferFrom(owner, msg.sender, tokenId);
    (bool success1, ) = owner.call{value: order.price}("");
    if (!success1) revert();
    (bool success2, ) = msg.sender.call{value: msg.value - order.price}("");
    if (!success2) revert();
  }
}
