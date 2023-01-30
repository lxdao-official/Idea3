// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721Tradable is ERC721 {
    struct TraderOrder {
        address lister;
        uint256 price;
        uint256 list_time;
        uint256 duration;
    }

    mapping(uint256 => TraderOrder) private _orderForTokenId;

    event Listed(
        uint256 indexed tokenId,
        address indexed lister,
        uint256 price,
        uint256 list_time,
        uint256 duration
    );

    event Bought(
        uint256 indexed tokenId,
        address indexed buyer,
        address indexed seller,
        uint256 price
    );

    function list(
        uint256 tokenId,
        uint256 price,
        uint256 duration
    ) public {
        require(msg.sender == ownerOf(tokenId), "Not owner");
        require(price > 0, "Price must be greater than 0");
        require(duration > 0, "Duration must be greater than 0");
        _orderForTokenId[tokenId] = TraderOrder(
            msg.sender,
            price,
            block.timestamp,
            duration
        );
        emit Listed(tokenId, msg.sender, price, block.timestamp, duration);
    }

    function buy(uint256 tokenId) public payable {
        require(msg.sender != ownerOf(tokenId));
        TraderOrder memory order = _orderForTokenId[tokenId];
        require(order.lister != address(0), "Token not listed");

        require(msg.value >= order.price, "Insufficient funds");
        require(
            block.timestamp <= order.list_time + order.duration,
            "Order expired"
        );

        address seller = ownerOf(tokenId);

        require(seller == order.lister, "Seller is not the lister");

        super._transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);

        delete _orderForTokenId[tokenId];

        emit Bought(tokenId, msg.sender, seller, msg.value);
    }

    function orderOfTokenId(uint256 tokenId)
        public
        view
        returns (TraderOrder memory)
    {
        return _orderForTokenId[tokenId];
    }
}
