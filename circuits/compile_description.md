## Compile description

circom zkp.circom --r1cs --wasm --sym
npx snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
npx snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
npx snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
npx snarkjs groth16 setup zkp.r1cs pot12_final.ptau zkp_0000.zkey
npx snarkjs zkey contribute zkp_0000.zkey zkp_final.zkey --name="LKH Second Contribution" -v
npx snarkjs zkey export verificationkey zkp_final.zkey verification_key.json
npx snarkjs zkey export solidityverifier zkp_final.zkey verifier.sol
node zkp_js/generate_witness.js zkp_js/zkp.wasm input.json zkp_js/witness.wtns
npx snarkjs groth16 prove zkp_final.zkey zkp_js/witness.wtns proof.json public.json
npx snarkjs groth16 verify verification_key.json public.json proof.json
npx snarkjs generatecall

## Assumption paramters

```mermaid

graph TB

A(10943297147418195642806126244953139466765067253851767347406559838166239123207)
B(2942450938471687433639690339733452416542326919507654606858684261476163891295)
C(14693904821945502268578313651525098196765636411922213115469821563817117273617)
D(19372501226129528824345446018646602194007058152094609827715516759785487890142)
E(14763215145315200506921711489642608356394854266165572616578112107564877678998)
F(1879402270149794212432036740081454186623842057661213288749068713224962094903)
G(19419916100242727769718322657520778503680617689214632373938093157277816551712)
H(18586133768512220936620570745912940619677854269274689475585506675881198879027)
I(2)
J(3)
K(4)
L(5)
M(6)
N(7)
O(8)

A-->B
A-->C
B-->D
B-->E
C-->F
C-->G
D-->H
D-->I
E-->J
E-->K
F-->L
F-->M
G-->N
G-->O
   
```
