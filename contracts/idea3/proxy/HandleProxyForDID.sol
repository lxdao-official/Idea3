// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IHandleProxy.sol";
import "../../base/did/IDID.sol";
import "../../base/lib/ownable.sol";

contract HandleProxyForDID is IHandleProxy, Ownable {
    IDID private did;

    constructor(address _didAddress) {
        did = IDID(_didAddress);
    }

    function getHandleByAddress(address _address)
        public
        view
        returns (string memory)
    {
        return did.resolveAddressToDid(_address);
    }

    function setDIDAddress(address _didAddress) public onlyOwner {
        did = IDID(_didAddress);
    }
}
