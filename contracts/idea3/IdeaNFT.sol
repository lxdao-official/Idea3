// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IIdeaSBT.sol";
import "./../tradable/ERC721Tradable.sol";
import "../lib/ownable.sol";

contract IdeaNFT is ERC721Tradable, Ownable {
    IIdeaSBT public ideaSBT;

    constructor(address _ideaSBT) ERC721("Idea3NFT", "Idea3NFT") {
        ideaSBT = IIdeaSBT(_ideaSBT);
    }

    function approveIdea(uint256 ideaId) public onlyOwner {
        address submitter = ideaSBT.approveIdea(ideaId);
        _safeMint(submitter, ideaId);
    }

    // function unapproveIdea(uint256 ideaId) public onlyOwner {
    //     ideaSBT.unapproveIdea(ideaId);
    //     _burn(ideaId);
    // }

    function approveIdeas(uint256[] memory ideaIds) public onlyOwner {
        for (uint256 i = 0; i < ideaIds.length; i++) {
            approveIdea(ideaIds[i]);
        }
    }

    // function unapproveIdeas(uint256[] memory ideaIds) public onlyOwner {
    //     for (uint256 i = 0; i < ideaIds.length; i++) {
    //         unapproveIdea(ideaIds[i]);
    //     }
    // }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return ideaSBT.tokenURI(tokenId);
    }
}
