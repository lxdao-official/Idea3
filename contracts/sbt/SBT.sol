// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract SBT is ERC721 {
    function approve(address to, uint256 tokenId) public virtual override {
        revert("canot approve");
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert("canot transfer");
    }
}
