pragma circom 2.1.6;
include "circomlib/poseidon.circom";

template MerkleTree8 () {
    signal input leaves[8];
    signal output root;

    // 第一層：8 個 Poseidon(1)
    component leafHashes[8];
    for (var i = 0; i < 8; i++) {
        leafHashes[i] = Poseidon(1);
        leafHashes[i].inputs[0] <== leaves[i];
        log("XXXX:", leafHashes[i].out);
    }

    // 第二層：4 個 Poseidon(2)
    component level1[4];
    for (var i = 0; i < 4; i++) {
        level1[i] = Poseidon(2);
        level1[i].inputs[0] <== leafHashes[i*2].out;
        level1[i].inputs[1] <== leafHashes[i*2+1].out;
        log("XXXX:", level1[i].out);
    }

    // 第三層：2 個 Poseidon(2)
    component level2[2];
    for (var i = 0; i < 2; i++) {
        level2[i] = Poseidon(2);
        level2[i].inputs[0] <== level1[i*2].out;
        level2[i].inputs[1] <== level1[i*2+1].out;
        log("XXXX:", level2[i].out);
    }

    // 第四層：Root
    component finalRoot = Poseidon(2);
    finalRoot.inputs[0] <== level2[0].out;
    finalRoot.inputs[1] <== level2[1].out;
    log("XXXX:", finalRoot.out);

    // root <== finalRoot.out;
}

component main = MerkleTree8();

/* INPUT = {
    "leaves": [
        "1111",
        "2222",
        "3333",
        "4444",
        "5555",
        "6666",
        "7777",
        "8888"
    ]
} */