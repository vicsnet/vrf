// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract joinGameContract {
    // 1. 0xA7b61B666905aaD7ceFA57D84A26569739EBBAfF
    // 2. 0xD3CD0f0902b832051eB544F3d12e4Ce0Dc20A1Bf
    constructor() payable {}

    receive() external payable {}

    function joinGame(address _addr) public payable {
        (bool success, ) = _addr.call{value: address(this).balance}(
            abi.encodeWithSignature("joinGame()")
        );

        require(success, "Tx failed send");
    }
}