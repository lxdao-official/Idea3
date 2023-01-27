// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/ownable.sol";
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";

abstract contract SBT is ERC721A, Ownable, ERC721AQueryable {
    // function _beforeTokenTransfers(
    //     address from,
    //     address to,
    //     uint256 startTokenId,
    //     uint256 quantity
    // ) internal virtual override {
    //     require(balanceOf(to) == 0, "already minted");
    // }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable virtual override {
        revert("canot transfer");
    }
}
