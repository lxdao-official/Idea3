// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IIdeaSBT {
    function approveIdea(uint256 id) external;

    function unapproveIdea(uint256 id) external;

    function tokenURI(uint256 id) external view returns (string memory);
}
