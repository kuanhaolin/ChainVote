import { ethers } from "ethers";
import fs from "fs";
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function main() {
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
  
  const privateKey = process.env.DEPLOYER_WALLET_PRIVATE_KEY;
  const wallet = new ethers.Wallet(privateKey, provider); // wallet private key

  // deploy verifier contract
  const contractPath = join(__dirname, "../artifacts/contracts/verifier.sol/Groth16Verifier.json");
  const contractJson = JSON.parse(fs.readFileSync(contractPath, "utf8"));
  const factory = new ethers.ContractFactory(contractJson.abi, contractJson.bytecode, wallet);
  const verifier = await factory.deploy();
  await verifier.waitForDeployment();
  const verifierAddress = await verifier.getAddress();
  // console.log("合約部署成功！");
  // console.log("合約地址:", address);
  // console.log("部署錢包地址:", wallet.address);

  const latestNonce = await wallet.getNonce();
  console.log("當前最新 Nonce 應該為:", latestNonce);

  const privateKey01 = process.env.DEPLOYER_WALLET_PRIVATE_KEY01;
  const wallet01 = new ethers.Wallet(privateKey01, provider); // wallet private key

  // deploy ballotManager contract
  const ballotManagerPath = join(__dirname, "../artifacts/contracts/ballotManager.sol/ballotManager.json");    
  const ballotManagerJson = JSON.parse(fs.readFileSync(ballotManagerPath, "utf8"));
  const ballotFactory = new ethers.ContractFactory(ballotManagerJson.abi, ballotManagerJson.bytecode, wallet);
  const args = [
    verifierAddress, // verifier's address
    "1957502675450735006995294171749393708380816510550016513572325377928709312799", // root
    "222222", // nullifier
    ["LIN", "KUAN", "HAO"], // names
    ["QmHashA123", "QmHashB456", "QmHashC789"], // ipfsCID
    60 // durationTime
  ];
  const ballotManager = await ballotFactory.deploy(...args, { nonce: latestNonce });
  await ballotManager.waitForDeployment();
  const ballotManagerAddress01 = await ballotManager.getAddress();
  console.log("合約部署成功！地址:", ballotManagerAddress01);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    // console.error("部署錯誤:", error.message);
    // console.error(error);
    process.exit(1);
  });
