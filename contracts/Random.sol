// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
contract GenerateRandomNo is VRFConsumerBaseV2, ConfirmedOwner{

    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);


    struct RequestStatus{
        bool fulfilled; //wheather the request has been successfully fulfilled
        bool exist; //whether a requestId exist
        uint256[] randomWords;
    }

    mapping(uint256 => RequestStatus) public s_request;

       VRFCoordinatorV2Interface COORDINATOR;

    //    subscription Id
    uint64 s_subscriptionId;

    // past requests Id
    uint256[] public requestIds;
    uint256 public lastRequestId;    

    bytes32 immutable keyHash;
    address public immutable linkToken;

    uint32 callbackGasLimit = 150000;
    uint16 requestConfirmations = 3;
    uint32 numWords =1;
    uint public randomWordsNum;

    address[] public players;

    uint maxPlayers;

    bool public gameStarted;
    uint public entryfee;
    uint public gameId;

    address public recentWinner;

    event GameStarted(uint gameId, uint maxPlayers, uint entryfee);
    event PlayerJoined(uint gameId, address player);
    event GameEnded(uint gameId, address winner);

    address VRF_Coordinator= 	0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    constructor(uint64 subscriptionId, address _linkToken) VRFConsumerBaseV2(VRF_Coordinator) ConfirmedOwner(msg.sender){
        COORDINATOR = VRFCoordinatorV2Interface(VRF_Coordinator);

        s_subscriptionId = subscriptionId;
        keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        linkToken =_linkToken;

        gameStarted = false;


    }

    function startGame(uint _maxPlayers, uint _entryfee) public{
        require(!gameStarted, "the Game has Started");
        
        players = new address[](0);
        
        maxPlayers = _maxPlayers;
        
        gameStarted = true;

        entryfee = _entryfee;
        gameId +=1;
    }

    function joinGame() public payable{
        require(gameStarted, "The game has not kicked off");
        require(players.length < maxPlayers, "The game is filled up");

        require(msg.value == entryfee, "The amount should be equal");
        players.push(msg.sender);

        emit PlayerJoined(gameId, msg.sender);

        if(players.length == maxPlayers){
            getRandomWinner();
        }

    }

    function getRandomWinner() internal returns(address){
        uint256 requestId = requestRandomWords();

        uint256 winnerIndex = randomWordsNum % players.length;

        recentWinner = players[winnerIndex];

        (bool success,) = recentWinner.call{value: address(this).balance}("");
        require(success, "Could not send ether");
        gameStarted = false;

        emit GameEnded(gameId, recentWinner);
        return recentWinner;
    }
    function requestRandomWords() public onlyOwner returns(uint256 requestId){

        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        s_request[requestId] = RequestStatus({
            randomWords:new uint256[](0),
            exist:true,
            fulfilled:false
            }
        );
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;


    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override{
        require(s_request[_requestId].exist,"Request not found ");
        s_request[_requestId].fulfilled = true;
        s_request[_requestId].randomWords = _randomWords;
        randomWordsNum = _randomWords[0];

        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(uint256 _requestId) external view returns(bool fulfilled, uint256[] memory randomWords){
        require(s_request[_requestId].exist,"request not found");
        RequestStatus memory request = s_request[_requestId];
        return (request.fulfilled, request.randomWords);
    }
}