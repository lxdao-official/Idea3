// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../base/lib/StringUtils.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

abstract contract IdeaImage {
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
        uint256 ideaId,
        address _addr,
        string memory _name,
        string memory _title,
        string memory _desc,
        bool isApproved
    ) internal pure virtual returns (string memory) {
        string memory _animate = _animateText(
            StringUtils.addressToString(_addr)
        );
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
            "<foreignObject width='360' height='250'>"
            "<body xmlns='http://www.w3.org/1999/xhtml' style='margin:0;padding:0;'>"
            "<p style='font-size:24px;margin:0;color:#fff;'>";
        string
            memory _sec = "</p> <p style='font-size:14px;margin:0;color:#fff;margin-top:16px;'>";
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
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                abi.encodePacked(
                                    _start,
                                    "#",
                                    Strings.toString(ideaId),
                                    " ",
                                    _title,
                                    _sec,
                                    _desc
                                ),
                                abi.encodePacked(
                                    _3,
                                    isApproved ? "Yes" : "No",
                                    _4,
                                    _name,
                                    _animate
                                )
                            )
                        )
                    )
                )
            );
    }
}
