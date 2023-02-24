// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract SBT721 is ERC721 {
    function approve(address to, uint256 tokenId) public virtual override {
        revert("canot approve");
    }

    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        revert("canot approve");
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(from == address(0), "canot transfer");
    }
}
