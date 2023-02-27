// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../base/topic/Topic.sol";
import "./IdeaImage.sol";
import "../base/lib/ownable.sol";
import "./IIdeaSBT.sol";
import "../base/metadata/DynamicMetadata.sol";
import "../base/lib/StringUtils.sol";
import "./proxy/IHandleProxy.sol";

/// @title Idea Smart Bussiness Token
/// @author 1998
/// @notice This contract is used to create and manage ideas
contract IdeaSBT is IdeaImage, DynamicMetadata, Topic, Ownable, IIdeaSBT {
    /// @dev The address of the HandleProxy contract, used to get the handle of an address from different protocols
    IHandleProxy private _handleProxy;

    /// @dev Whether to check the handle of the submitter
    bool private _checkHandle = true;

    /// @dev The address of the approver, only the approver can approve or unapprove ideas
    address private _approver;

    /// @dev Whether to charge a fee for submitting an idea
    bool private _feeOn = false;

    /// @dev The fee for submitting an idea
    uint256 private _fee = 0.1 ether;

    /// @dev ideas approved status
    mapping(uint256 => bool) public isIdeaApproved;

    event IdeaApproved(uint256 id);
    event IdeaUnapproved(uint256 id);

    /// @dev extends of topic struct
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

    constructor(address _handleProxy_) ERC721("Idea3SBT", "Idea3SBT") {
        _handleProxy = IHandleProxy(_handleProxy_);
    }

    function submitIdea(
        string memory title,
        string memory desc,
        string memory markdown
    ) external payable {
        // check handle
        if (_checkHandle) {
            string memory handle = _handleProxy.getHandleByAddress(msg.sender);
            require(!StringUtils.isEmpty(handle), "no handle found");
        }

        if (_feeOn) {
            if (balanceOf(owner) > 1) {
                require(msg.value >= 0.01 ether, "Fee not paid");
            }
        }
        _submit(title, desc, markdown);
    }

    function approveIdea(uint256 id) external {
        require(_approver == msg.sender, "Only approver can approve ideas");
        require(isIdeaApproved[id] == false, "Idea already approved");
        isIdeaApproved[id] = true;
        emit IdeaApproved(id);
    }

    function unapproveIdea(uint256 id) external {
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
            _getAddressDid(topic.submitter)
        );
        return idea;
    }

    function getIdeas(uint256[] memory _ideaIds)
        external
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
    ) external {
        TopicStruct memory topic = _getTopic(id);
        require(topic.submitter == msg.sender, "Only submitter can edit idea");
        _editTopic(id, title, desc, markdown);
    }

    /// @dev get the handle of an address for internal use
    function _getAddressDid(address address_)
        private
        view
        returns (string memory)
    {
        string memory didstr = _handleProxy.getHandleByAddress(address_);
        if (StringUtils.isEmpty(didstr)) {
            return StringUtils.addressToString(address_);
        } else {
            return didstr;
        }
    }

    ///@dev ERC721 override
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, IIdeaSBT)
        returns (string memory)
    {
        require(_exists(tokenId), "tokenId doesn't exist");
        return _dynamicTokenURI(tokenId);
    }

    ///@dev DynamicMetadata override
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
            _getAddressDid(idea.submitter),
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
        _checkHandle = checkDid;
    }

    function setHandleProxy(address _handleProxy_) public onlyOwner {
        _handleProxy = IHandleProxy(_handleProxy_);
    }

    function editIdeaByOwner(
        uint256 id,
        string memory title,
        string memory desc,
        string memory markdown
    ) external onlyOwner {
        _editTopic(id, title, desc, markdown);
    }

    /// @dev withdraw
    function withdraw(address payable recipient) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = recipient.call{value: balance}("");
        require(success, "fail withdraw");
    }

    fallback() external payable {}

    receive() external payable {}
}
