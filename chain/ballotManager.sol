// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./verifier.sol";

contract ballotManager{
    Groth16Verifier public verifier;

    struct candidate{
        string name;
        string ipfsCID;
        uint256[2][2] voteCount;
    }
    candidate[] public candidates;
    uint256 public root;
    uint256 public nullifier;
    mapping(uint256 => bool) public hasVoted_nullifier;
    uint256[2] public pk;
    uint256 public votingDeadline;

    event Vote(uint256 indexed nullifierHash, uint256[2][2] vote01Count, uint256[2][2] vote02Count, uint256[2][2] vote03Count);

    // verifier.sol's address
    constructor(
        address _verifierAddress, 
        uint256 _officialRoot, 
        uint256 _nullifier,
        uint256[2] memory _pk,
        string[] memory _names,
        string[] memory _ipfsCID,
        uint256 _durationTime
    ){
        verifier = Groth16Verifier(_verifierAddress);
        root = _officialRoot;
        nullifier = _nullifier;
        pk = _pk;
        votingDeadline = block.timestamp + (_durationTime * 1 minutes);
        for(uint256 i = 0; i < _names.length; i++) {
            uint256[2][2] memory initCount;
            initCount[0][0] = 0;
            initCount[0][1] = 1;
            initCount[1][0] = 0;
            initCount[1][1] = 1;
            candidates.push(candidate({
                name: _names[i],
                ipfsCID: _ipfsCID[i],
                voteCount: initCount
            }));
        }
    }

    function vote(
        uint[2] memory _proofa,
        uint[2][2] memory _proofb,
        uint[2] memory _proofc,
        uint[17] memory _input
    ) public {
        // check
        require(block.timestamp < votingDeadline, "Voting period has ended!!!");
        require(_input[14] == root, "Invalid root!!!");
        require(_input[13] == nullifier, "Invalid nullifier!!!");
        require(_input[15] == pk[0] && _input[16] == pk[1], "Invalid public key!!!");
        require(!hasVoted_nullifier[_input[0]], "You have voted already!!!");
        require(verifier.verifyProof(_proofa, _proofb, _proofc, _input), "Invalid proof!!!");
        
        // update state
        hasVoted_nullifier[_input[0]] = true;
        for (uint256 i = 0; i < candidates.length; i++) {
            candidates[i].voteCount[0][0] += _input[i*2+1];
            candidates[i].voteCount[0][1] += _input[i*2+2];
            candidates[i].voteCount[1][0] += _input[i*2+7];
            candidates[i].voteCount[1][1] += _input[i*2+8];
        }
        emit Vote(_input[0], candidates[0].voteCount, candidates[1].voteCount, candidates[2].voteCount);
    }

    function getCandidates() public view returns(candidate[] memory){
        return candidates;
    }
}