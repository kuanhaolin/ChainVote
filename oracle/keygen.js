const { buildBabyjub } = require("circomlibjs");

async function main() {
    const babyJub = await buildBabyjub();
    const F = babyJub.F;
    const G = babyJub.Base8;
    
    // secret keys
    const sk1 = BigInt(Math.floor(Math.random() * 10**20));
    const sk2 = BigInt(Math.floor(Math.random() * 10**20));
    const sk3 = BigInt(Math.floor(Math.random() * 10**20));
    const skTotal = sk1 + sk2 + sk3;

    // public key
    const pk = babyJub.mulPointEscalar([G[0], G[1]], skTotal);

    // show keys
    console.log("sk01:", sk1.toString());
    console.log("sk02:", sk2.toString());
    console.log("sk03:", sk3.toString());
    console.log("pkX:", F.toObject(pk[0]).toString());
    console.log("pkY:", F.toObject(pk[1]).toString());
    console.log("gX:", F.toObject(G[0]).toString());
    console.log("gY:", F.toObject(G[1]).toString());
}


main().catch((err) => {
    console.error(err);
    process.exit(1);
});
