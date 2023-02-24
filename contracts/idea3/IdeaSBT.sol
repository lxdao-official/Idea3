// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../topic/Topic.sol";
import "./Metadata.sol";
import "../lib/ownable.sol";
import "./IIdeaSBT.sol";

contract IdeaSBT is IdeaMetadata, Topic, Ownable, IIdeaSBT {
    address private _approver;
    // open service fee
    bool private _feeOn = false;
    uint256 private _fee = 0.1 ether;

    mapping(uint256 => bool) public isIdeaApproved;

    constructor() ERC721("Idea3SBT", "Idea3SBT") {}

    event IdeaApproved(uint256 id);
    event IdeaUnapproved(uint256 id);

    struct IdeaStruct {
        uint256 id;
        string title;
        string desc;
        string markdown;
        address submitter;
        uint256 createAt;
        uint256 updateAt;
        bool approved;
    }

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
        uint256 id = _submit(title, desc, markdown);
    }

    function approveIdea(uint256 id) public {
        require(_approver == msg.sender, "Only approver can approve ideas");
        require(isIdeaApproved[id] == false, "Idea already approved");
        isIdeaApproved[id] = true;
        emit IdeaApproved(id);
    }

    function unapproveIdea(uint256 id) public {
        require(_approver == msg.sender, "Only approver can unapprove ideas");
        require(isIdeaApproved[id] == true, "Idea already unapproved");
        isIdeaApproved[id] = false;
        emit IdeaUnapproved(id);
    }

    function getIdea(uint256 id) public view returns (IdeaStruct memory idea) {
        TopicStruct memory topic = _getTopic(id);
        idea = IdeaStruct(
            topic.id,
            topic.title,
            topic.desc,
            topic.markdown,
            topic.submitter,
            topic.createAt,
            topic.updateAt,
            isIdeaApproved[id]
        );
        return idea;
    }

    function getIdeas(uint256[] memory _ideaIds)
        public
        view
        returns (IdeaStruct[] memory)
    {
        IdeaStruct[] memory ideaArray = new IdeaStruct[](_ideaIds.length);
        for (uint256 i = 0; i < _ideaIds.length; i++) {
            ideaArray[i] = getIdea(_ideaIds[i]);
        }
        return ideaArray;
    }

    function editIdeaBySubmitter(
        uint256 id,
        string memory title,
        string memory desc,
        string memory markdown,
        string memory submitterName
    ) public {
        TopicStruct memory topic = _getTopic(id);
        require(topic.submitter == msg.sender, "Only submitter can edit idea");
        _editTopic(id, title, desc, markdown);
    }

    function editIdeaByOwner(
        uint256 id,
        string memory title,
        string memory desc,
        string memory markdown
    ) public onlyOwner {
        _editTopic(id, title, desc, markdown);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, IIdeaSBT)
        returns (string memory)
    {
        require(_exists(tokenId), "tokenId doesn't exist");
        return _createTokenURI(getIdea(tokenId));
    }

    /// @dev onlyOwner functions
    function setApprover(address approver) public onlyOwner {
        _approver = approver;
    }

    function setFeeOn(bool feeOn) public onlyOwner {
        _feeOn = feeOn;
    }

    function setFee(uint256 fee) public onlyOwner {
        _fee = fee;
    }

    function setCanEdit(bool canEdit) public onlyOwner {
        _canEdit = canEdit;
    }
}
