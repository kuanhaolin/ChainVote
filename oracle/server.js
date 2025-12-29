require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();
const {ethers} = require('ethers');

app.use(cors());
app.use(express.json());

// simulated verification db
const govdb =[
    {id: 1, idcard: "1234", healthcard: "1234"},
]

// connect to blockchain
const provider = new ethers.JsonRpcProvider("http://blockchain-node:8545");
const privateKey = process.env.DEPLOYER_WALLET_PRIVATE_KEY;
const wallet = new ethers.Wallet(privateKey, provider); // wallet private key
const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3" // contract address
const abi = [
    "function authorizeVoter(address _voter) public",
    "function voters(address) public view returns (bool isAuthorized, bool hasVoted, uint256 voteIndex)",
];
const contract = new ethers.Contract(contractAddress, abi, wallet);

// post
app.post('/api/verify', async (req, res) => {
    const { idCardNumber, healthCardNumber, userAddress } = req.body;
    
    if (!userAddress || userAddress === "") {
        return res.status(400).json({ verified: false, message: "Wallet address error!!!" });
    }

    const founduser = govdb.find(user => user.idcard === idCardNumber && user.healthcard === healthCardNumber);
    const voterInfo = await contract.voters(userAddress);
    
    if (founduser && !voterInfo.isAuthorized) {
        const tx = await contract.authorizeVoter(userAddress);
        const receipt = await tx.wait();
        res.json({verified: true, message: "Success", txHash: receipt.hash});
    } else if (founduser && voterInfo.isAuthorized) {
        res.json({ verified: true, message: "Already authorized, you can vote" });
    } else {
        res.json({ verified: false, message: "Failed" });
    }
});

app.listen(3001, () => {
    console.log("Oracle on http://localhost:3001");
});