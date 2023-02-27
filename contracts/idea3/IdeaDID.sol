// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../base/did/DID.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract IdeaDID is DID {
    constructor(bool _isFree_) ERC721("IdeaDID", "IdeaDID") {
        name_suffix = ".idea";
        description = "Idea3 DID";
        image_prefix = "";
        _isFree = _isFree_;
    }
}
