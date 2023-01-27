// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../lib/ownable.sol";
import "../tradable/ERC721Tradable.sol";

contract IdeaNFT is ERC721Tradable, Ownable {
    string private URI;

    constructor() ERC721("Idea3", "Idea3") {}

    function setBaseURI(string memory __baseURI) public onlyOwner {
        URI = __baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return URI;
    }
}
