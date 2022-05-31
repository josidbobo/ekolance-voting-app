// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7;

//import "https://github.com/Ekolance/Voting-Smart-Contract-Interface/blob/main/IVotingContract.sol";
import "./IVotingContract.sol";

contract MyVotingApp is IVotingContract{
    struct Voter {
        bool hasVoted; 
    }

     struct Candidate {
        bytes32 name;   
        uint voteCount; 
    }


    event CandidateAdded (Candidate _candidate);
    event ChairPersonChangedTo (address newChairPerson);

    uint deployedTime;

    address public chairperson;

    mapping(address => Voter) public voters;

    Candidate[] public candidates;

    modifier onlyChairperson(){
        require(msg.sender == chairperson, "Only Chairperson is allowed to add candidates");
        _;
    }
    
    // Voting time has elapsed
    modifier votingEnded(){
        require(block.timestamp < deployedTime + 360, "Voting has ended");
        _;
    }
    
    // Check that voter has not voted before
    modifier alreadyVoted(){
        require (voters[msg.sender].hasVoted == false, "You have already voted");
        _;
    }
    
    // Prevent adding the same candidate twice
    modifier noDuplicates(bytes32 _candidate){
        for(uint i = 0; i < candidates.length; i++){
            if(candidates[i].name == (_candidate)){
                revert ("Candidate already exists");
            }
        }
        _;
    }



    constructor(){
        chairperson = msg.sender;
        deployedTime = block.timestamp;
    }

    function changeChairperson(address _chairperson) public onlyChairperson returns(bool)  {
        chairperson = _chairperson;
        emit ChairPersonChangedTo(_chairperson);
        return true;
    }

    function addCandidate(bytes32 candidate)  external override onlyChairperson noDuplicates(candidate) returns(bool) {
        require (block.timestamp < deployedTime + 180, "Window to add candidate has passed");
        candidates.push(Candidate({
            name:candidate,
            voteCount:0
        }));
        emit CandidateAdded(Candidate({
            name:candidate,
            voteCount:0
        }));
        return true;
    }

    function voteCandidate(uint candidateId) external override votingEnded alreadyVoted returns(bool) {
        require (block.timestamp > deployedTime + 180, "Kindly wait, candidates are being added.");
        candidates[candidateId].voteCount += 1;
        voters[msg.sender].hasVoted = true;
        return true;
    }

    //getWinner returns the name of the winner
    function getWinner() external override view returns(bytes32){
        require(block.timestamp > deployedTime + 360, "Voting isnt over yet");
        uint initialHigh = 0;
        for(uint index = 0; index < candidates.length; index++){
            if (candidates[index].voteCount > candidates[initialHigh].voteCount){
                initialHigh = index;
            } 
        }
        return candidates[initialHigh].name;

        /* 
        The code to convert to string is marked in arrow, but I don't think it's necessary cos of gas fees 
        and we would have to alter the IVoting interface cos the return types differ.

        ///  --->  string memory convt_bytes = string(candidates[initialHigh].name);
                    return convt_bytes;

        */
            }
        }

        /*
 [
     Test  cases
     "0x4d75626172617100000000000000000000000000000000000000000000000000",
 "0x4f6f6b616e000000000000000000000000000000000000000000000000000000",
 "0x4c6177616c000000000000000000000000000000000000000000000000000000"
 ]
*/
