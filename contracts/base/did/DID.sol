// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/ownable.sol";
import "../lib/StringUtils.sol";
import "./Price.sol";
import "./Metadata.sol";
import "./DIDResolver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

abstract contract DID is ERC721, Ownable, Price, Metadata, DIDResolver {
    bool public isOpen = true;

    uint256 private _nextTokenId = 1;
    event Minted(address indexed to, uint256 indexed _amount, string did);

    function setIsFree(bool _isFree_) public onlyOwner {
        _isFree = _isFree_;
    }

    function mint(string calldata did) external payable {
        require(isOpen, "not open");
        require(getPrice(did) <= msg.value, "no enough eth");
        _mint(msg.sender, did);
    }

    function _mint(address to, string calldata did) internal {
        require(!checkExist(did), "did already minted");
        uint256 tokenId = _nextTokenId;
        _safeMint(to, tokenId);
        addRecord(did, tokenId);
        _nextTokenId++;
        emit Minted(msg.sender, 1, did);
    }

    /**
     * lock did to current address
     */
    function lockDid(string calldata did) external {
        require(checkExist(did), "did not minted");
        uint256 tokenId = resolveDidToTokenId(did);
        require(ownerOf(tokenId) == msg.sender, "not owner");
        lockToAddress(tokenId, msg.sender);
    }

    /**
     * unlock did from current address
     */
    function unlockDid(string calldata did) external {
        require(checkExist(did), "did not minted");
        uint256 tokenId = resolveDidToTokenId(did);
        require(ownerOf(tokenId) == msg.sender, "not owner");
        unlockAddress(msg.sender);
    }

    /**
     * can't transfer locked token
     */
    function approve(address to, uint256 tokenId) public virtual override {
        require(!isTokenIdLocked(tokenId), "token locked");
    }

    /**
     * can't transfer locked token
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(!isTokenIdLocked(tokenId), "token locked");
    }

    /// @dev ERC721

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "tokenId doesn't exist");
        string memory did = tokenIdToDid[tokenId];
        return _createTokenURI(tokenId, did);
    }

    /// @dev owner actions
    function mintByOwner(address _to, string calldata did) external onlyOwner {
        _mint(_to, did);
    }

    function setOpen(bool _isOpen) external onlyOwner {
        isOpen = _isOpen;
    }

    /// @dev withdraw all eth
    function withdraw(address payable recipient) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = recipient.call{value: balance}("");
        require(success, "fail withdraw");
    }

    fallback() external payable {}

    receive() external payable {}
}
