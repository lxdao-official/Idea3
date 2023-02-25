// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../base/topic/Topic.sol";
import "./IdeaImage.sol";
import "../base/lib/ownable.sol";
import "./IIdeaSBT.sol";
import "../base/metadata/DynamicMetadata.sol";
import "../base/did/IDID.sol";
import "../base/lib/StringUtils.sol";

contract IdeaSBT is IdeaImage, DynamicMetadata, Topic, Ownable, IIdeaSBT {
    address private _approver;
    bool private _checkDid = true;
    // open service fee
    bool private _feeOn = false;
    uint256 private _fee = 0.1 ether;

    IDID private _did;
    mapping(uint256 => bool) public isIdeaApproved;

    constructor(address _didAddress) ERC721("Idea3SBT", "Idea3SBT") {
        _did = IDID(_didAddress);
    }

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
        string submitterDID;
    }

    function getAddressDid(address address_)
        public
        view
        returns (string memory)
    {
        string memory didstr = _did.resolveAddressToDid(address_);
        if (StringUtils.isEmpty(didstr)) {
            return StringUtils.addressToString(address_);
        } else {
            return didstr;
        }
    }

    function submitIdea(
        string memory title,
        string memory desc,
        string memory markdown
    ) public payable {
        // check did
        if (_checkDid) {
            uint256 tokenId = _did.resolveAddressToTokenId(msg.sender);
            require(tokenId > 0, "DID not registered");
        }

        if (_feeOn) {
            if (balanceOf(owner) > 1) {
                require(msg.value >= 0.01 ether, "Fee not paid");
            }
        }
        _submit(title, desc, markdown);
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
            isIdeaApproved[id],
            getAddressDid(topic.submitter)
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
        string memory markdown
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
        return _dynamicTokenURI(tokenId);
    }

    ///@dev DynamicMetadata
    function _getName(uint256 _tokenId)
        internal
        view
        virtual
        override
        returns (string memory name)
    {
        name = string(
            abi.encodePacked(
                "#",
                Strings.toString(_tokenId),
                " ",
                getIdea(_tokenId).title
            )
        );
    }

    function _getDescription(uint256 _tokenId)
        internal
        view
        virtual
        override
        returns (string memory desc)
    {
        desc = getIdea(_tokenId).desc;
    }

    function _getImage(uint256 _tokenId)
        internal
        view
        virtual
        override
        returns (string memory image)
    {
        IdeaStruct memory idea = getIdea(_tokenId);
        image = _createImage(
            _tokenId,
            idea.submitter,
            getAddressDid(idea.submitter),
            idea.title,
            idea.desc,
            idea.approved
        );
    }

    function _getExternalUrl(uint256 _tokenId)
        internal
        view
        virtual
        override
        returns (string memory url)
    {}

    function _getAttributes(uint256 _tokenId)
        internal
        view
        virtual
        override
        returns (string[] memory keys, string[] memory values)
    {
        IdeaStruct memory idea = getIdea(_tokenId);
        keys = new string[](2);
        values = new string[](2);
        keys[0] = "submitter";
        values[0] = StringUtils.addressToString(idea.submitter);
        keys[1] = "approved";
        values[1] = idea.approved ? "YES" : "NO";
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

    function setCheckDid(bool checkDid) public onlyOwner {
        _checkDid = checkDid;
    }
}
