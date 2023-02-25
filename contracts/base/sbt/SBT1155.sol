// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

abstract contract SBT1155 is ERC1155 {
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        revert("canot approve");
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        require(from == address(0), "canot transfer");
    }
}
