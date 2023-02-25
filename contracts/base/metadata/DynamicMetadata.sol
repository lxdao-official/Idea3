// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../lib/StringUtils.sol";
import "../lib/ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

abstract contract DynamicMetadata {
    function _getName(uint256 _tokenId)
        internal
        view
        virtual
        returns (string memory name)
    {}

    function _getDescription(uint256 _tokenId)
        internal
        view
        virtual
        returns (string memory desc)
    {}

    function _getImage(uint256 _tokenId)
        internal
        view
        virtual
        returns (string memory image)
    {}

    function _getExternalUrl(uint256 _tokenId)
        internal
        view
        virtual
        returns (string memory url)
    {}

    function _getAttributes(uint256 _tokenId)
        internal
        view
        virtual
        returns (string[] memory keys, string[] memory values)
    {}

    function _getAttributesStr(uint256 _tokenId)
        internal
        view
        virtual
        returns (string memory attributes)
    {
        string[] memory keys;
        string[] memory values;
        (keys, values) = _getAttributes(_tokenId);
        attributes = "[";
        for (uint256 i = 0; i < keys.length; i++) {
            attributes = string(
                abi.encodePacked(
                    attributes,
                    '{"trait_type": "',
                    keys[i],
                    '", "value": "',
                    values[i],
                    '"}'
                )
            );
            if (i < keys.length - 1) {
                attributes = string(abi.encodePacked(attributes, ","));
            }
        }
        attributes = string(abi.encodePacked(attributes, "]"));
    }

    function _dynamicTokenURI(uint256 tokenId)
        internal
        view
        virtual
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"name": "',
                            _getName(tokenId),
                            '","description": "',
                            _getDescription(tokenId),
                            '","external_url": "',
                            _getExternalUrl(tokenId),
                            '","image": "',
                            _getImage(tokenId),
                            '","attributes": ',
                            _getAttributesStr(tokenId),
                            "}"
                        )
                    )
                )
            );
    }
}
