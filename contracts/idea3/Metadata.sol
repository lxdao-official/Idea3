// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../lib/StringUtils.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

import "./IdeaSBT.sol";

abstract contract IdeaMetadata {
    function _animateText(string memory _addr)
        internal
        pure
        virtual
        returns (string memory)
    {
        string memory _1 = "</p>"
        "</div>"
        "<div>"
        "<p style='font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;'>";
        string memory _2 = "</p>"
        "</div>"
        "</body>"
        "</foreignObject>"
        "</g>"
        "<text text-rendering='optimizeSpeed'>"
        "<textPath startOffset='-100%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>";
        string
            memory _3 = "<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' />"
            "</textPath>"
            "<textPath startOffset='0%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>";
        string
            memory _4 = "<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' />"
            "</textPath>"
            "<textPath startOffset='-50%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>";
        string
            memory _5 = "<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' />"
            "</textPath>"
            "<textPath startOffset='50%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>";
        string
            memory _6 = "<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' />"
            "</textPath>"
            "</text>"
            "</g>"
            "</svg>";
        return
            string(
                abi.encodePacked(
                    abi.encodePacked(_1, _addr, _2, _addr, _3, _addr),
                    abi.encodePacked(_4, _addr, _5, _addr, _6)
                )
            );
    }

    function _createImage(
        IdeaSBT.IdeaStruct memory idea,
        bytes memory _id,
        string memory _addr
    ) internal pure virtual returns (bytes memory) {
        string memory _animate = _animateText(_addr);
        string
            memory _start = "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1024' height='1024' viewBox='0 0 400 400' fill='none'>"
            "<defs>"
            "<path xmlns='http://www.w3.org/2000/svg' id='text-path-a' d='M 20 10 H 380 A 28 28 0 0 1 390 20 V 380 A 28 28 0 0 1 380 390 H 20 A 28 28 0 0 1 10 380 V 20 A 28 28 0 0 1 20 10 z' />"
            "<clipPath xmlns='http://www.w3.org/2000/svg' id='corners'>"
            "<rect width='400' height='400' rx='18' ry='18' />"
            "</clipPath>"
            "</defs>"
            "<g opacity='1' transform='translate(0 0)' font-family='Courier New, monospace'>"
            "<g xmlns='http://www.w3.org/2000/svg' clip-path='url(#corners)'>"
            "<rect x='0' y='0' width='400' height='400' rx='15' ry='15' fill='rgba(40,40,40,1)' />"
            "</g>"
            "<g opacity='1' transform='translate(25 25) '>"
            "<foreignObject width='360' height='60'>"
            "<body xmlns='http://www.w3.org/1999/xhtml' style='margin:0;padding:0;'>"
            "<p style='font-size:24px;margin:0;color:#fff;'>";
        string memory _sec = "</p>"
        "</body>"
        "</foreignObject>"
        "</g>"
        "<g opacity='1' transform='translate(25 99) '>"
        "<foreignObject width='360' height='210'>"
        "<body xmlns='http://www.w3.org/1999/xhtml' style='margin:0;padding:0;'>"
        "<p style='font-size:16px;margin:0;color:#fff;'>";
        string memory _3 = "</p>"
        "</body>"
        "</foreignObject>"
        "</g>"
        "<g xmlns='http://www.w3.org/2000/svg' transform='translate(25 280) '>"
        "<foreignObject width='350' height='100'>"
        "<body xmlns='http://www.w3.org/1999/xhtml' style='margin:0;padding:0;padding-top:5px;'>"
        "<div style='margin-bottom:15px;'>"
        "<p style='display:inline;font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;'>"
        "<span style='color:rgba(255,255,255,0.6)'>Approved </span>";
        string memory _4 = "</p>"
        "</div>"
        "<div style='margin-bottom:12px;'>"
        "<p style='display:inline;font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;'>"
        "<span style='color:rgba(255,255,255,0.6)'>Idea by </span>";
        return
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            abi.encodePacked(
                                _start,
                                _id,
                                idea.title,
                                _sec,
                                idea.desc
                            ),
                            abi.encodePacked(
                                _3,
                                idea.approved ? "Yes" : "No",
                                _4,
                                //,
                                _animate
                            )
                        )
                    )
                )
            );
    }

    function _createTokenURI(IdeaSBT.IdeaStruct memory idea)
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
                                idea.desc,
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
