// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../lib/StringUtils.sol";
import "../lib/ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

import "./Idea.sol";

abstract contract IdeaMetadata is Ownable {
    function _animateText(string memory _addr)
        internal
        pure
        virtual
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    '</p></div><div><p style="font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;">0x',
                    _addr,
                    '</p></div></body></foreignObject></g><text text-rendering="optimizeSpeed"><textPath startOffset="-100%" fill="#000" font-size="12px" font-weight="500" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#text-path-a">0x',
                    _addr,
                    ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s"  repeatCount="indefinite" /></textPath><textPath startOffset="0%" fill="#000"  font-size="12px" font-weight="500" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#text-path-a">0x',
                    _addr,
                    ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s"  repeatCount="indefinite" /></textPath></text></g></svg>'
                )
            );
    }

    function _createImage(
        Idea.IdeaStruct memory idea,
        bytes memory _id,
        string memory _addr
    ) internal pure virtual returns (bytes memory) {
        string memory _animate = _animateText(_addr);
        return
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            abi.encodePacked(
                                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="1024" height="1024"  viewBox="0 0 400 400" fill="none"><defs><path xmlns="http://www.w3.org/2000/svg" id="text-path-a"  d="M 20 10 H 380 A 28 28 0 0 1 390 20 V 380 A 28 28 0 0 1 380 390 H 20 A 28 28 0 0 1 10 380 V 20 A 28 28 0 0 1 20 10 z" /><filter xmlns="http://www.w3.org/2000/svg" id="f1"><feImage result="p0" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nNDAwJyBoZWlnaHQ9JzQwMCcgdmlld0JveD0nMCAwIDQwMCA0MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PHJlY3Qgd2lkdGg9JzQwMHB4JyBoZWlnaHQ9JzQwMHB4JyBmaWxsPScjYTBiODY5Jy8+PC9zdmc+" /><feImage result="p1" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nNDAwJyBoZWlnaHQ9JzQwMCcgdmlld0JveD0nMCAwIDQwMCA0MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nMTAwJyBjeT0nMzAwJyByPScxMjBweCcgZmlsbD0nI2MwMmFhYScvPjwvc3ZnPg==" /><feImage result="p2" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nNDAwJyBoZWlnaHQ9JzQwMCcgdmlld0JveD0nMCAwIDQwMCA0MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nMTQ2JyBjeT0nMTI0JyByPScxMjBweCcgZmlsbD0nIzM5OWVmYScvPjwvc3ZnPg==" /><feImage result="p3" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nNDAwJyBoZWlnaHQ9JzQwMCcgdmlld0JveD0nMCAwIDQwMCA0MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nMzMxJyBjeT0nMjM2JyByPScxMDBweCcgZmlsbD0nIzk3NTdmZicvPjwvc3ZnPg==" /><feBlend mode="overlay" in="p0" in2="p1" /><feBlend mode="exclusion" in2="p2" /><feBlend mode="overlay" in2="p3" result="blendOut" /><feGaussianBlur in="blendOut" stdDeviation="42" /></filter><clipPath xmlns="http://www.w3.org/2000/svg" id="corners"><rect width="400" height="400" rx="18" ry="18" /></clipPath><rect id="path_0" x="0" y="0" width="100" height="26" /><linearGradient id="linear_0" x1="103%" y1="49%" x2="-3%" y2="49%" gradientUnits="objectBoundingBox"><stop offset="0" stop-color="#00FB8C" stop-opacity="1" /><stop offset="0.0971267" stop-color="#64CCEB" stop-opacity="1" /><stop offset="0.276683" stop-color="#64CCEB" stop-opacity="1" /><stop offset="0.319606" stop-color="#64CCEB" stop-opacity="1" /><stop offset="0.697546" stop-color="#0F39D9" stop-opacity="1" /><stop offset="0.806149" stop-color="#0F39D9" stop-opacity="1" /><stop offset="1" stop-color="#64CCEB" stop-opacity="1" /></linearGradient><linearGradient id="linear_1" x1="77%" y1="78%" x2="24%" y2="8%" gradientUnits="objectBoundingBox"><stop offset="0" stop-color="#00FB8C" stop-opacity="1" /><stop offset="0.0958371" stop-color="#64CCEB" stop-opacity="1" /><stop offset="0.477009" stop-color="#64CCEB" stop-opacity="1" /><stop offset="0.646695" stop-color="#64CCEB" stop-opacity="1" /><stop offset="1" stop-color="#0F39D9" stop-opacity="1" /></linearGradient></defs><g opacity="1" transform="translate(0 0)" font-family="Courier New, monospace"><g xmlns="http://www.w3.org/2000/svg" clip-path="url(#corners)"><rect fill="a0b869" x="0px" y="0px" width="400px" height="400px" /><rect style="filter: url(#f1)" x="0px" y="0px" width="400px" height="400px" /><rect x="0" y="0" width="400" height="400" rx="15" ry="15" fill="rgba(255,255,255,0.4)" /><rect x="13" y="13" width="374" height="374" rx="15" ry="15" stroke="rgba(255,255,255,0.1)" /></g><g opacity="1" transform="translate(25 25) "><foreignObject width="360" height="60"><body xmlns="http://www.w3.org/1999/xhtml" style="margin:0;padding:0;"><p style="font-size:24px;margin:0;color:#000;">',
                                _id,
                                idea.title,
                                '</p></body></foreignObject></g><g opacity="1" transform="translate(25 99) "><foreignObject width="360" height="210"><body xmlns="http://www.w3.org/1999/xhtml" style="margin:0;padding:0;"><p style="font-size:16px;margin:0;color:#666;">',
                                idea.content
                            ),
                            abi.encodePacked(
                                '</p></body></foreignObject></g><g xmlns="http://www.w3.org/2000/svg" transform="translate(25 280) "><foreignObject width="350" height="100"><body xmlns="http://www.w3.org/1999/xhtml" style="margin:0;padding:0;padding-top:5px;"><div style="margin-bottom:15px;"><p style="display:inline;font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;"><span style="color:rgba(255,255,255,0.6)">Approved</span> ',
                                idea.approved ? "Yes" : "No",
                                '</p></div><div style="margin-bottom:12px;"><p style="display:inline;font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;"><span style="color:rgba(255,255,255,0.6)">Idea by</span> ',
                                idea.submitterName,
                                _animate
                            )
                        )
                    )
                )
            );
    }

    function _createTokenURI(Idea.IdeaStruct memory idea)
        internal
        view
        virtual
        returns (string memory)
    {
        string memory _addr = addressToString(idea.submitter);
        bytes memory _id = abi.encodePacked(
            "#",
            Strings.toString(idea.id),
            " "
        );
        bytes memory image = _createImage(idea, _id, _addr);

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                _id,
                                idea.title,
                                '","description": "',
                                idea.content,
                                '", "image": "',
                                image,
                                '", "attributes": [{"trait_type": "Approved", "value": "',
                                idea.approved ? "Yes" : "No",
                                '"},{"trait_type": "Submitter", "value": "',
                                _addr,
                                '"}] }'
                            )
                        )
                    )
                )
            );
    }

    function addressToString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
