// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ballotManager.sol";

contract ballotManager{
    Groth16Verifier public verifier;

    uint256 public candidate01Count;
    uint256 public candidate02Count;
    uint256 public candidate03Count;
    uint256 public root;
    uint256 public nullifier;
    mapping(uint256 => bool) public hasVoted_nullifier;

    // verifier.sol's address
    constructor(address _verifierAddress, uint256 _officialRoot, uint256 _nullifier){
        verifier = Groth16Verifier(_verifierAddress);
        root = _officialRoot;
        nullifier = _nullifier;
    }

    function vote(uint[2] memory _proofa, uint[2][2] memory _proofb, uint[2] memory _proofc, uint[6] memory _input) public {
        // check root
        require(_input[4] == root, "Invalid root!!!");
        // check nullifier
        require(_input[5] == nullifier, "Invalid nullifier!!!");
        // check double spending
        require(!hasVoted_nullifier[_input[0]], "You have voted already!!!");
        // check proof validity
        require(verifier.verifyProof(_proofa, _proofb, _proofc, _input), "Invalid proof!!!");
        
        // update state
        hasVoted_nullifier[_input[0]] = true;
        if(_input[1] == 1) candidate01Count += 1;
        if(_input[2] == 1) candidate02Count += 1;
        if(_input[3] == 1) candidate03Count += 1;
    }
}