// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

struct Order {
  address owner;
  uint256 price;
}

struct OrderView {
  IERC721 erc721;
  uint256 tokenId;
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
  OrderView[] public orderViews;

  function _orderIsValid(IERC721 erc721, uint256 tokenId) internal view {
    Order storage order = orders[address(erc721)][tokenId];
    if (order.owner == address(0)) revert();
    _checkOperable(order.owner, erc721, tokenId);
    _checkOperable(address(this), erc721, tokenId);
  }
  modifier orderIsValid(IERC721 erc721, uint256 tokenId) {
    _orderIsValid(erc721, tokenId);
    _;
  }

  event LimitSellEvent(
    IERC721 indexed erc721,
    uint256 indexed tokenId,
    uint256 ethPrice
  );
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
    OrderView memory orderView = OrderView(erc721, tokenId, order.owner, order.price);
    orderViews.push(orderView);
    emit LimitSellEvent(erc721, tokenId, ethPrice);
  }

  error PriceNotEnough(
    IERC721 erc721,
    uint256 tokenId,
    uint256 price,
    uint256 value
  );
  error PaymentError(address target, uint256 amount);
  error ChangeError(address target, uint256 amount);
  function targetedBuy(
    IERC721 erc721,
    uint256 tokenId
  ) external payable orderIsValid(erc721, tokenId) {

    Order storage order = orders[address(erc721)][tokenId];
    if (msg.value < order.price)
      revert PriceNotEnough(erc721, tokenId, order.price, msg.value);

    address owner = erc721.ownerOf(tokenId);
    erc721.safeTransferFrom(owner, msg.sender, tokenId);

    (bool paymentSuccess, ) = order.owner.call{ value: order.price }("");
    if (!paymentSuccess) revert PaymentError(order.owner, order.price);

    uint256 change = msg.value - order.price;
    if (change > 0) {
      (bool changeSuccess, ) = msg.sender.call{ value: change }("");
      if (!changeSuccess) revert ChangeError(msg.sender, change);
    }

    delete orders[address(erc721)][tokenId];
  }
}
