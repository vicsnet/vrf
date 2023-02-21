// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract GenerateRandNo is VRFConsumerBaseV2, ConfirmedOwner{


    address _Cordinator_Address =0xAE975071Be8F8eE67addBC1A82488F1C24858067; 
    uint64 subscriptionId = 10090;
    bytes32 keyHash =0x6e099d640cde6de9d40ac749b4b594126b0169747122711109c9985d47751f93; 

    uint32 callbackGasLimit = 100000;

 
    uint16 requestConfirmations = 3;


    uint32 numWords = 1;

    uint256 public LastIdRequest ;
    uint256 public randomNo;

VRFCoordinatorV2Interface COORDINATOR;

event RequestSent(uint256 requestId, uint32 numWords);
    constructor () VRFConsumerBaseV2(_Cordinator_Address) ConfirmedOwner(msg.sender){
        // subscriptionId;
            COORDINATOR = VRFCoordinatorV2Interface(_Cordinator_Address);

    }

    function requestRandomWords()
        external
        onlyOwner
        returns (uint256)
    {
        // Will revert if subscription is not set and funded.
        uint256 requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        LastIdRequest = requestId;
        // s_requests[requestId] = RequestStatus({
        //     randomWords: new uint256[](0),
        //     exists: true,
        //     fulfilled: false
        // });
        // requestIds.push(requestId);
        // lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId/1e76;
    }

      function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        LastIdRequest=_requestId;
        // require(s_requests[_requestId].exists, "request not found");
        // s_requests[_requestId].fulfilled = true;
        // s_requests[_requestId].randomWords = _randomWords;
        // emit RequestFulfilled(_requestId, _randomWords);
        randomNo =_randomWords[0];
    }


}