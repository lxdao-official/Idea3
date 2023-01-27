// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./../sbt/SBT.sol";

contract POAP is SBT {
    string private URI;

    constructor(string memory name, string memory symbol)
        ERC721A(name, symbol)
    {}

    mapping(uint256 => uint256) public ideaIdOfTokenId;

    function setBaseURI(string memory __baseURI) public onlyOwner {
        URI = __baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return URI;
    }

    function mint(address to, uint256 ideaId) public onlyOwner {
        uint256 tokenId = _nextTokenId();
        _safeMint(to, 1);
        ideaIdOfTokenId[tokenId] = ideaId;
    }

    function getIdeaIdByTokenId(uint256 tokenId) public view returns (uint256) {
        return ideaIdOfTokenId[tokenId];
    }
}
