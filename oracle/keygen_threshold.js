const { Scalar } = require("ffjavascript");
const { buildBabyjub } = require("circomlibjs");
const crypto = require("crypto");
// order of curve
const r = BigInt("2736030358979909402780800718157159386076813972158567259200215660948447373041");

// get random bigint
function getRandomBigInt() {
    return BigInt("0x" + crypto.randomBytes(32).toString("hex")) % r;
}

function generateThresholdShares(totalSk, n, t) {
    const sk = BigInt(totalSk.toString());
    // t=0, sk = coefficient[0]
    const coefficients = [sk];
    // get random a1, a2, ..., a(t-1)
    for (let i = 1; i < t; i++) {
        coefficients.push(getRandomBigInt());
    }

    const shares = [];
    // calculate f(x)
    for (let j = 1; j <= n; j++) {
        const x = BigInt(j);
        let val = coefficients[0];
        // calculate each term, sk+a1*x^k+a2*x^2
        for (let k = 1; k < t; k++) {
            let xPow = 1n;
            // mod first, otherwise value will become extremely large
            for (let p = 0; p < k; p++) {
                xPow = (xPow * x) % r;
            }
            let term = (coefficients[k]*xPow) % r;
            val = (val + term) % r;
        }
        shares.push({
            id: j,
            share: Scalar.fromString(val.toString())
            // share: Scalar.mod(Scalar.fromString(val.toString()),r)
        })
    }
    return shares;
}

async function main() {
    const babyJub = await buildBabyjub();
    const F = babyJub.F;
    const G = babyJub.Base8;
    const totalSk = getRandomBigInt();
    // const totalSk = BigInt("1097094918319998294314187");
    const pk = babyJub.mulPointEscalar(G, totalSk);
    const allShares = generateThresholdShares(totalSk, 5, 3);
    console.log("Mastersk:", totalSk.toString());
    console.log("pkX:", F.toObject(pk[0]).toString());
    console.log("pkY:", F.toObject(pk[1]).toString());
    console.log("Shares:", allShares);
}

main().catch(console.error);
