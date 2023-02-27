// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IHandleProxy.sol";
import "../../base/did/IDIDResolver.sol";
import "../../base/lib/ownable.sol";

contract HandleProxyForDID is IHandleProxy, Ownable {
    IDIDResolver private did;

    constructor(address _didAddress) {
        did = IDIDResolver(_didAddress);
    }

    function getHandleByAddress(address _address)
        public
        view
        returns (string memory)
    {
        return did.resolveAddressToDid(_address);
    }

    function setDIDAddress(address _didAddress) public onlyOwner {
        did = IDIDResolver(_didAddress);
    }
}
