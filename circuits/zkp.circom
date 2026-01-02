pragma circom 2.1.6;

include "./node_modules/circomlib/circuits/poseidon.circom";
include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/escalarmulany.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

template Zkp () {
    signal input userSecret;
    signal input nullifier;
    signal input candidateIndex;
    signal input pathElements[3];
    signal input pathIndices[3]; // 0: you are at left, i: you are at right
    signal input root;
    signal input r[3];
    signal input pk[2]; // x and y
    signal output nullifierHash;
    signal output c1[3][2];
    signal output c2[3][2];
    
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

    component voteCheck02 = IsEqual();
    voteCheck02.in[0] <== candidateIndex;
    voteCheck02.in[1] <== 2;

    component voteCheck03 = IsEqual();
    voteCheck03.in[0] <== candidateIndex;
    voteCheck03.in[1] <== 3;

    signal totalVotes;
    totalVotes <== voteCheck01.out + voteCheck02.out + voteCheck03.out;
    totalVotes === 1;


    // default G
    var G[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];
    component mulG[3];
    component mulPk[3];
    component mulG2[3];
    component voteResult[3];
    component addC2[3];
    component rBits[3];
    component vBits[3];

    for (var i = 0; i < 3; i++) {
        // cal c1 r*G
        mulG[i] = EscalarMulAny(253);
        mulG[i].p[0] <== G[0];
        mulG[i].p[1] <== G[1];
        rBits[i] = Num2Bits(253);
        rBits[i].in <== r[i];
        for (var j = 0; j < 253; j++) {
            mulG[i].e[j] <== rBits[i].out[j];
        }
        c1[i][0] <== mulG[i].out[0];
        c1[i][1] <== mulG[i].out[1];

        // cal c2 r*pk
        mulPk[i] = EscalarMulAny(253);
        mulPk[i].p[0] <== pk[0];
        mulPk[i].p[1] <== pk[1];
        mulPk[i].e <== mulG[i].e;
        // mulPk[i].e <== r[i];
        // cal c2 v*G
        mulG2[i] = EscalarMulAny(253);
        mulG2[i].p[0] <== G[0];
        mulG2[i].p[1] <== G[1];
        voteResult[i] = IsEqual();
        voteResult[i].in[0] <== candidateIndex;
        voteResult[i].in[1] <== i + 1;
        vBits[i] = Num2Bits(253);
        vBits[i].in <== voteResult[i].out;
        for (var k = 0; k < 253; k++){
            mulG2[i].e[k] <== vBits[i].out[k];
        }
        // mulG2[i].e <== voteResult[i].out;
        // cal c2 (r*pk)+(v*G)
        addC2[i] = BabyAdd();
        addC2[i].x1 <== mulPk[i].out[0];
        addC2[i].y1 <== mulPk[i].out[1];
        addC2[i].x2 <== mulG2[i].out[0];
        addC2[i].y2 <== mulG2[i].out[1];
        c2[i][0] <== addC2[i].xout;
        c2[i][1] <== addC2[i].yout;
    }

    // merkle tree
    component hashers[3];
    signal levelHashes[4];
    signal left[3];
    signal right[3];
    levelHashes[0] <== hash.out;
    for (var i = 0; i < 3; i++) {
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

component main {public [root, nullifier, pk]} = Zkp();

/* INPUT = {
    "userSecret": "1111",
    "nullifier": "222222",
    "candidateIndex": "1",
    "pathElements": ["19690291642042494239924132103815711450334047642868793290286571338144171123023", "1036650162605266689155569618988935551591700558940979379371025402092498979322", "17318907088932163993936474574301200048277266577227880388615604770703611868473"],
    "pathIndices": ["0", "0", "0"],
    "root": "1957502675450735006995294171749393708380816510550016513572325377928709312799",
    "r": ["111111", "222222", "333333"],
    "pk": ["52996116721742748390185309041599639970583252277898463051156141015564638851929673472", "184455211488781598053849569779033123744019454629295409564625478870442159963563"]
} */