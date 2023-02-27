// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Interface for the HandleProxy contract
/// @author 1998
/// @notice This interface is used to get the handle of an address, it can be implemented by any contract, and replace on the fly

interface IHandleProxy {
    function getHandleByAddress(address _address)
        external
        view
        returns (string memory);
}
