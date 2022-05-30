// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;


//import "https://github.com/Ekolance/Voting-Smart-Contract-Interface/blob/main/IVotingContract.sol";
import "./IVotingContract.sol";

contract MyVotingApp is IVotingContract{
    struct Voter {
        bool hasVoted;  // if true, that person already voted
        uint vote;   // index of the voted candidate
    }

     struct Candidate {
        // If you can limit the length to a certain number of bytes, 
        // always use one of bytes1 to bytes32 because they are much cheaper
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
        //uint candidateId;
    }

    uint deployedTime;
    address public chairperson;

    mapping(address => Voter) public voters;

    Candidate[] public candidates;


    constructor(){
        chairperson = msg.sender;
        deployedTime = block.timestamp;
    }

    function addCandidate(bytes32 candidate)  external override  returns(bool) {
        require (msg.sender == chairperson, "Only Chairperson is allowed to add candidates");
        require (block.timestamp < deployedTime + 180, "Window to add candidate has passed");
        candidates.push(Candidate({
            name:candidate,
            voteCount:0
        }));
    return true;
}



function voteCandidate(uint candidateId) external override returns(bool){
    require (block.timestamp > deployedTime + 180, "Kindly wait, candidates are being added.");
    require (block.timestamp < deployedTime + 360, "Voting has ended");
    require (voters[msg.sender].hasVoted == false, "You have already voted");
    candidates[candidateId].voteCount += 1;
    voters[msg.sender].hasVoted = true;
    return true;
}

//getWinner returns the name of the winner
    function getWinner() external override view returns(bytes32){
        uint initialHigh = 0;
        for(uint index = 0; index < candidates.length; index++){
            if (candidates[index].voteCount > candidates[initialHigh].voteCount){
                initialHigh = index;
            } 
        }
        return candidates[initialHigh].name;
        //return initialHigh;
        //return "";
    }
}

/*
[
     "0x4d75626172617100000000000000000000000000000000000000000000000000",
 "0x4f6f6b616e000000000000000000000000000000000000000000000000000000",
 "0x4c6177616c000000000000000000000000000000000000000000000000000000"
 ]
*/