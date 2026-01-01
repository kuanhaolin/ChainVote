// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./verifier.sol";

contract ballotManager{
    Groth16Verifier public verifier;

    struct candidate{
        string name;
        string ipfsCID;
        uint256 voteCount;
    }
    candidate[] public candidates;
    uint256 public root;
    uint256 public nullifier;
    mapping(uint256 => bool) public hasVoted_nullifier;
    uint256 public votingDeadline;

    event Vote(uint256 indexed nullifierHash, uint256 candidate01, uint256 candidate02, uint256 candidate03);

    // verifier.sol's address
    constructor(
        address _verifierAddress, 
        uint256 _officialRoot, 
        uint256 _nullifier,
        string[] memory _names,
        string[] memory _ipfsCID,
        uint256 _durationTime
    ){
        verifier = Groth16Verifier(_verifierAddress);
        root = _officialRoot;
        nullifier = _nullifier;
        votingDeadline = block.timestamp + (_durationTime * 1 minutes);
        for(uint256 i = 0; i < _names.length; i++) {
            candidates.push(candidate({
                name: _names[i],
                ipfsCID: _ipfsCID[i],
                voteCount: 0
            }));
        }
    }

    function vote(
        uint[2] memory _proofa,
        uint[2][2] memory _proofb,
        uint[2] memory _proofc,
        uint[6] memory _input
    ) public {
        // check
        require(block.timestamp < votingDeadline, "Voting period has ended!!!");
        require(_input[5] == root, "Invalid root!!!");
        require(_input[4] == nullifier, "Invalid nullifier!!!");
        require(!hasVoted_nullifier[_input[0]], "You have voted already!!!");
        require(verifier.verifyProof(_proofa, _proofb, _proofc, _input), "Invalid proof!!!");
        
        // update state
        hasVoted_nullifier[_input[0]] = true;
        if(_input[1] == 1) candidates[0].voteCount += 1;
        if(_input[2] == 1) candidates[1].voteCount += 1;
        if(_input[3] == 1) candidates[2].voteCount += 1;
        emit Vote(_input[0], _input[1], _input[2], _input[3]);
    }

    function getCandidates() public view returns(candidate[] memory){
        return candidates;
    }
}