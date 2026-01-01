pragma circom 2.1.6;

include "./node_modules/circomlib/circuits/poseidon.circom";
include "./node_modules/circomlib/circuits/comparators.circom";

template Example () {
    signal input userSecret;
    signal input nullifier;
    signal input candidateIndex;
    signal input pathElements[3];
    signal input pathIndices[3]; // 0: you are at left, i: you are at right
    signal input root;
    signal output nullifierHash;
    signal output voteFor01;
    signal output voteFor02;
    signal output voteFor03;
    
    // commitment
    component hash = Poseidon(1);
    hash.inputs[0] <== userSecret;
    // log("hash:", hash.out);

    // nullifier
    component nhash = Poseidon(2);
    nhash.inputs[0] <== userSecret;
    nhash.inputs[1] <== nullifier;
    nullifierHash <== nhash.out;

    //
    component gte = GreaterEqThan(32);
    gte.in[0] <== candidateIndex;
    gte.in[1] <== 1;
    gte.out === 1;

    component lte = LessEqThan(32);
    lte.in[0] <== candidateIndex;
    lte.in[1] <== 3;
    lte.out === 1;

    component voteCheck01 = IsEqual();
    voteCheck01.in[0] <== candidateIndex;
    voteCheck01.in[1] <== 1;
    voteFor01 <== voteCheck01.out;

    component voteCheck02 = IsEqual();
    voteCheck02.in[0] <== candidateIndex;
    voteCheck02.in[1] <== 2;
    voteFor02 <== voteCheck02.out;

    component voteCheck03 = IsEqual();
    voteCheck03.in[0] <== candidateIndex;
    voteCheck03.in[1] <== 3;
    voteFor03 <== voteCheck03.out;

    signal totalVotes;
    totalVotes <== voteFor01 + voteFor02 + voteFor03;
    totalVotes === 1;

    // merkle tree
    component hashers[3];
    signal levelHashes[4];
    signal left[3];
    signal right[3];
    levelHashes[0] <== hash.out;
    for (var i = 0; i < 3; i++){
        hashers[i] = Poseidon(2);
        left[i] <== (pathElements[i] - levelHashes[i]) * pathIndices[i] + levelHashes[i]; 
        right[i] <== (levelHashes[i] - pathElements[i]) * pathIndices[i] + pathElements[i];
        hashers[i].inputs[0] <== left[i];
        hashers[i].inputs[1] <== right[i];
        levelHashes[i+1] <== hashers[i].out;
    }
    // log("Calculated Root:", levelHashes[3]);
    root === levelHashes[3];

}

component main {public [root, nullifier]} = Example();

/* INPUT = {
    "userSecret": "1",
    "nullifier": "222222",
    "candidateIndex": "1",
    "pathElements": ["2", "14763215145315200506921711489642608356394854266165572616578112107564877678998", "14693904821945502268578313651525098196765636411922213115469821563817117273617"],
    "pathIndices": ["0", "0", "0"],
    "root": "10943297147418195642806126244953139466765067253851767347406559838166239123207"
} */