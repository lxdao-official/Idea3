// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IHandleProxy.sol";

contract HandleProxy is IHandleProxy {
    function getHandleByAddress(address _address)
        public
        view
        returns (string memory)
    {}
}
