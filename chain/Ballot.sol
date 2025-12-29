// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ballot{
    struct Voter{
        bool isAuthorized; // verify oracle state
        bool hasVoted; // verify duplicate voting
        uint256 voteIndex; // vote candidate
    }

    struct Candidate{
        string name;
        string ipfsCID; // info
        uint256 voteCount; // counting
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint256 public votingDeadline;

    event AuthorizeVoter(address voter);
    event VoteCandidate(address voter, uint256 candidateIndex);

    // Init
    constructor(string[] memory _names, string[] memory _ipfsCID, uint256 _durationTime){
        chairperson = msg.sender;
        votingDeadline = block.timestamp + (_durationTime * 1 minutes);
        for(uint256 i = 0; i < _names.length; i++){
            candidates.push(Candidate({
                name: _names[i],
                ipfsCID: _ipfsCID[i],
                voteCount:0 
            }));
        } 
    }

    // Oracle authorize voter status.
    function authorizeVoter(address _voter) public {
        require(msg.sender == chairperson, "Only oracle can authorize!!!");
        require(!voters[_voter].isAuthorized, "Voter has Authorized!!!");
        require(!voters[_voter].hasVoted, "Voter has voted!!!");
        voters[_voter].isAuthorized = true;
        emit AuthorizeVoter(_voter); // return to oracle
    }

    // Voter vote.
    function voteCandidate(uint256 _candidateIndex) public {
        Voter storage sender = voters[msg.sender];
        require(block.timestamp < votingDeadline, "Voting period has ended!!!");
        require(sender.isAuthorized, "You are not authorized!!!");
        require(!sender.hasVoted, "You has voted!!!");
        require(_candidateIndex < candidates.length, "Invalid candiate!!!");
        sender.hasVoted = true;
        sender.voteIndex = _candidateIndex;
        candidates[_candidateIndex].voteCount += 1;
        emit VoteCandidate(msg.sender, _candidateIndex); // return to web
    }

    // Election situation.
    function getCandidates() public view returns(Candidate[] memory){
        return candidates;
    }
}