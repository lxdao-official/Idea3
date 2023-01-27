// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IdeaNFT.sol";
import "./POAP.sol";
import "./Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract Idea is IdeaNFT, IdeaMetadata {
    mapping(uint256 => IdeaStruct) public ideas;

    POAP sbt;

    uint256 public ideaCount;

    struct IdeaStruct {
        uint256 id;
        string title;
        string content;
        address submitter;
        string submitterName;
        bool approved;
    }

    event IdeaSubmitted(
        uint256 id,
        string name,
        string content,
        address submitter,
        string submitterName
    );

    event IdeaApproved(uint256 id);

    constructor(address _sbt) {
        sbt = POAP(_sbt);
    }

    function submitIdea(
        string memory title,
        string memory content,
        string memory submitterName
    ) public {
        uint256 id = ideaCount;
        ideas[id] = IdeaStruct(
            id,
            title,
            content,
            msg.sender,
            submitterName,
            false
        );
        _safeMint(msg.sender, id);
        ideaCount++;

        emit IdeaSubmitted(id, title, content, msg.sender, submitterName);
    }

    function approveIdea(uint256 id) public onlyOwner {
        require(ideas[id].approved == false, "Idea already approved");
        ideas[id].approved = true;
        sbt.mint(msg.sender, id);
        emit IdeaApproved(id);
    }

    function getIdea(uint256 id)
        public
        view
        returns (
            string memory,
            string memory,
            address,
            string memory,
            bool
        )
    {
        return (
            ideas[id].title,
            ideas[id].content,
            ideas[id].submitter,
            ideas[id].submitterName,
            ideas[id].approved
        );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "tokenId doesn't exist");
        return _createTokenURI(ideas[tokenId]);
    }
}
