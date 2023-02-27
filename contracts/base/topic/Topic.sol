// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../sbt/SBT721.sol";
import "../lib/ownable.sol";

abstract contract Topic is SBT721 {
    mapping(uint256 => TopicStruct) public topics;

    bool internal _canEdit = true;

    uint256 public topicCount;

    struct TopicStruct {
        uint256 id;
        string title;
        string desc;
        string markdown;
        address submitter;
        uint256 createAt;
        uint256 updateAt;
    }

    event TopicSubmitted(
        uint256 id,
        string name,
        string desc,
        string markdown,
        address submitter
    );

    event MetadataUpdate(uint256 _tokenId);

    function _submit(
        string memory title,
        string memory desc,
        string memory markdown
    ) internal returns (uint256) {
        uint256 id = topicCount;
        topics[id] = TopicStruct(
            id,
            title,
            desc,
            markdown,
            msg.sender,
            block.timestamp,
            block.timestamp
        );
        _safeMint(msg.sender, id);
        topicCount++;
        emit TopicSubmitted(id, title, desc, markdown, msg.sender);
        return id;
    }

    function _getTopic(uint256 id) internal view returns (TopicStruct memory) {
        return topics[id];
    }

    function _editTopic(
        uint256 id,
        string memory title,
        string memory desc,
        string memory markdown
    ) internal {
        require(_canEdit, "Can not edit");
        topics[id].title = title;
        topics[id].desc = desc;
        topics[id].markdown = markdown;
        topics[id].updateAt = block.timestamp;
        emit MetadataUpdate(id);
    }
}
