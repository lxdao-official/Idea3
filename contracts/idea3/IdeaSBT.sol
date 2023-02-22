// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../sbt/SBT.sol";
import "./Metadata.sol";
import "hardhat/console.sol";
import "../lib/ownable.sol";
import "./IIdeaSBT.sol";

contract IdeaSBT is IdeaMetadata, SBT, Ownable, IIdeaSBT {
    mapping(uint256 => IdeaStruct) public ideas;

    address private _approver;
    // open service fee
    bool private _feeOn = false;
    uint256 private _fee = 0.1 ether;

    function setApprover(address approver) public onlyOwner {
        _approver = approver;
    }

    function setFeeOn(bool feeOn) public onlyOwner {
        _feeOn = feeOn;
    }

    function setFee(uint256 fee) public onlyOwner {
        _fee = fee;
    }

    constructor() ERC721("Idea3SBT", "Idea3SBT") {}

    uint256 public ideaCount;

    struct IdeaStruct {
        uint256 id;
        string title;
        string desc;
        string markdown;
        address submitter;
        string submitterName;
        bool approved;
    }

    event IdeaSubmitted(
        uint256 id,
        string name,
        string desc,
        string markdown,
        address submitter,
        string submitterName
    );

    event IdeaApproved(uint256 id);
    event IdeaUnapproved(uint256 id);

    function submitIdea(
        string memory title,
        string memory desc,
        string memory markdown,
        string memory submitterName
    ) public payable {
        if (_feeOn) {
            if (balanceOf(owner) > 1) {
                require(msg.value >= 0.01 ether, "Fee not paid");
            }
        }
        uint256 id = ideaCount;
        ideas[id] = IdeaStruct(
            id,
            title,
            desc,
            markdown,
            msg.sender,
            submitterName,
            false
        );
        _safeMint(msg.sender, id);
        ideaCount++;
        emit IdeaSubmitted(
            id,
            title,
            desc,
            markdown,
            msg.sender,
            submitterName
        );
    }

    function approveIdea(uint256 id) public returns (address) {
        require(_approver == msg.sender, "Only approver can approve ideas");
        require(ideas[id].approved == false, "Idea already approved");
        ideas[id].approved = true;
        emit IdeaApproved(id);
        return ideas[id].submitter;
    }

    function unapproveIdea(uint256 id) public {
        require(_approver == msg.sender, "Only approver can unapprove ideas");
        require(ideas[id].approved == true, "Idea already unapproved");
        ideas[id].approved = false;
        emit IdeaUnapproved(id);
    }

    function getIdea(uint256 id)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            address,
            string memory,
            bool,
            uint256
        )
    {
        return (
            ideas[id].title,
            ideas[id].desc,
            ideas[id].markdown,
            ideas[id].submitter,
            ideas[id].submitterName,
            ideas[id].approved,
            ideas[id].id
        );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, IIdeaSBT)
        returns (string memory)
    {
        require(_exists(tokenId), "tokenId doesn't exist");
        return _createTokenURI(ideas[tokenId]);
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "tokenId doesn't exist");
        return _createTokenURI(ideas[tokenId]);
    }

    function getIdeas(uint256[] memory _ideaIds)
        public
        view
        returns (IdeaStruct[] memory)
    {
        IdeaStruct[] memory ideaArray = new IdeaStruct[](_ideaIds.length);
        for (uint256 i = 0; i < _ideaIds.length; i++) {
            ideaArray[i] = ideas[_ideaIds[i]];
        }
        return ideaArray;
    }

    function editIdea(
        uint256 id,
        string memory title,
        string memory desc,
        string memory markdown,
        string memory submitterName
    ) public {
        require(
            ideas[id].submitter == msg.sender,
            "Only submitter can edit idea"
        );
        ideas[id].title = title;
        ideas[id].desc = desc;
        ideas[id].markdown = markdown;
        ideas[id].submitterName = submitterName;
    }

    function editIdeaByOwner(
        uint256 id,
        string memory title,
        string memory desc,
        string memory markdown,
        string memory submitterName
    ) public onlyOwner {
        ideas[id].title = title;
        ideas[id].desc = desc;
        ideas[id].markdown = markdown;
        ideas[id].submitterName = submitterName;
    }
}
