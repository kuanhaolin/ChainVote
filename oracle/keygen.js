const { buildBabyjub } = require("circomlibjs");
const crypto = require("crypto");

async function main() {
    const babyJub = await buildBabyjub();
    const F = babyJub.F;
    const G = babyJub.Base8;
    
    // generate secret keys
    function getSecureRandomBigInt() {
        const buf = crypto.randomBytes(10);
        return BigInt("0x" + buf.toString("hex"));
    }
    const sk1 = getSecureRandomBigInt();
    const sk2 = getSecureRandomBigInt();
    const sk3 = getSecureRandomBigInt();
    const skTotal = sk1 + sk2 + sk3;

    // public key
    const pk = babyJub.mulPointEscalar(G, skTotal);
    // show keys
    console.log("sk01:", sk1.toString());
    console.log("sk02:", sk2.toString());
    console.log("sk03:", sk3.toString());
    console.log("skTotal:", skTotal.toString());
    console.log("pkX:", F.toObject(pk[0]).toString());
    console.log("pkY:", F.toObject(pk[1]).toString());
    console.log("gX:", F.toObject(G[0]).toString());
    console.log("gY:", F.toObject(G[1]).toString());
}

main().catch(console.error);