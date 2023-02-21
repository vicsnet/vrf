// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract joinGameContract {
    constructor() payable {}

    receive() external payable {}

    function joinGame(address _addr) public payable {
        (bool success, ) = _addr.call{value: address(this).balance}(
            abi.encodeWithSignature("joinGame()")
        );

        require(success, "Tx failed send");
    }
}