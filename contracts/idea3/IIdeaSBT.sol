// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IIdeaSBT {
    function approveIdea(uint256 id) external;

    function unapproveIdea(uint256 id) external;

    function tokenURI(uint256 id) external view returns (string memory);
}
