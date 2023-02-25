// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../base/lib/ownable.sol";
import "../base/lib/StringUtils.sol";
import "../base/did/Price.sol";
import "../base/did/Metadata.sol";
import "../base/did/DID.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract IdeaDID is ERC721, Ownable, Price, Metadata, DID {
    bool private isOpen = false;

    uint256 private _nextTokenId = 1;

    constructor() ERC721("IdeaDID", "IdeaDID") {
        name_suffix = ".idea3.link";
        description = "Idea3 DID";
        image_prefix = "";
        uint256[] memory _rentPrices = new uint256[](5);
        _rentPrices[0] = 1 ether;
        _rentPrices[1] = 0.1 ether;
        _rentPrices[2] = 0.05 ether;
        _rentPrices[3] = 0.01 ether;
        _rentPrices[4] = 0.005 ether;
        initializePrice(_rentPrices);
    }

    /**
     * 将 did 锁定到当前地址
     */
    function lockDid(string calldata did) external {
        require(checkExist(did), "did not minted");
        uint256 tokenId = resolveDidToTokenId(did);
        require(ownerOf(tokenId) == msg.sender, "not owner");
        lockToAddress(tokenId, msg.sender);
    }

    /**
     * 将 did 解锁
     */
    function unlockDid(string calldata did) external {
        require(checkExist(did), "did not minted");
        uint256 tokenId = resolveDidToTokenId(did);
        require(ownerOf(tokenId) == msg.sender, "not owner");
        unlockAddress(msg.sender);
    }

    /**
     * 被锁定的 tokenId 不能转移
     */
    function approve(address to, uint256 tokenId) public virtual override {
        require(!isTokenIdLocked(tokenId), "token locked");
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(!isTokenIdLocked(tokenId), "token locked");
    }

    event Minted(address indexed to, uint256 indexed _amount, string did);

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

    function mintByOwner(address _to, string calldata did) external onlyOwner {
        _mint(_to, did);
    }

    function withdraw(address payable recipient) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = recipient.call{value: balance}("");
        require(success, "fail withdraw");
    }

    function updateOpen(bool _isOpen) external onlyOwner {
        isOpen = _isOpen;
    }

    function getOpen() external view returns (bool) {
        return isOpen;
    }

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

    fallback() external payable {}

    receive() external payable {}
}
