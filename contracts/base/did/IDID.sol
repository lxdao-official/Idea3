// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../lib/StringUtils.sol";
import "../lib/ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

interface IDID {
    function resolveTokenIdToAddress(uint256 tokenId)
        external
        view
        returns (address);

    function resolveAddressToTokenId(address address_)
        external
        view
        returns (uint256);

    function resolveDidToTokenId(string calldata did)
        external
        view
        returns (uint256);

    function resolveTokenIdToDid(uint256 tokenId)
        external
        view
        returns (string memory);

    function resolveDidToAddress(string calldata did)
        external
        view
        returns (address);

    function resolveAddressToDid(address address_)
        external
        view
        returns (string memory);
}
