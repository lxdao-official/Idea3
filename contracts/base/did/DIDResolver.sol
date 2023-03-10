// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IDIDResolver.sol";
import "../lib/StringUtils.sol";
import "../lib/ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/// @title DID basic contract, store and resolve did/address/tokenId
/// @author 1998
/// @notice This contract is used to store and resolve did/address/tokenId
abstract contract DIDResolver is Ownable, IDIDResolver {
    mapping(bytes32 => uint256) public didhashToTokenId;
    mapping(uint256 => string) public tokenIdToDid;

    mapping(uint256 => address) public tokenIdToAddress;
    mapping(address => uint256) public addressToTokenId;

    event DIDLocked(uint256 tokenId, address address_);
    event DIDUnlocked(uint256 tokenId, address address_);

    function lockToAddress(uint256 tokenId, address address_) internal {
        require(
            addressToTokenId[address_] == 0,
            "address already locked to token"
        );
        addressToTokenId[address_] = tokenId;
        tokenIdToAddress[tokenId] = address_;
        emit DIDLocked(tokenId, address_);
    }

    function unlockAddress(address address_) internal {
        uint256 tokenId = addressToTokenId[address_];
        require(tokenId != 0, "address not locked to token");
        delete addressToTokenId[address_];
        delete tokenIdToAddress[tokenId];
        emit DIDUnlocked(tokenId, address_);
    }

    function isTokenIdLocked(uint256 tokenId) internal view returns (bool) {
        return tokenIdToAddress[tokenId] != address(0);
    }

    function resolveTokenIdToAddress(uint256 tokenId)
        public
        view
        returns (address)
    {
        return tokenIdToAddress[tokenId];
    }

    function resolveAddressToTokenId(address address_)
        public
        view
        returns (uint256)
    {
        return addressToTokenId[address_];
    }

    function resolveDidToTokenId(string calldata did)
        public
        view
        returns (uint256)
    {
        bytes32 didhash = keccak256(abi.encodePacked(did));
        uint256 tokenId = didhashToTokenId[didhash];
        return tokenId;
    }

    function resolveTokenIdToDid(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        string memory did = tokenIdToDid[tokenId];
        return did;
    }

    function resolveDidToAddress(string calldata did)
        public
        view
        returns (address)
    {
        uint256 tokenId = resolveDidToTokenId(did);
        if (tokenId == 0) {
            return address(0);
        }
        return resolveTokenIdToAddress(tokenId);
    }

    function resolveAddressToDid(address address_)
        public
        view
        returns (string memory)
    {
        uint256 tokenId = resolveAddressToTokenId(address_);
        if (tokenId == 0) {
            return "";
        }
        return resolveTokenIdToDid(tokenId);
    }

    function addRecord(string calldata did, uint256 tokenId) internal {
        bytes32 didhash = keccak256(abi.encodePacked(did));
        require(didhashToTokenId[didhash] == 0, "did already minted");
        didhashToTokenId[didhash] = tokenId;
        tokenIdToDid[tokenId] = (did);
    }

    function checkExist(string calldata did) internal view returns (bool) {
        bytes32 didhash = keccak256(abi.encodePacked(did));
        return didhashToTokenId[didhash] != 0;
    }
}
