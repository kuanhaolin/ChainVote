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

  const names = ["LIN", "KUAN", "HAO"];
  const ipfsCIDs = ["QmHashA123", "QmHashB456", "QmHashC789"];
  const duration = 60; // mins

  const contractPath = join(__dirname, "../artifacts/contracts/Ballot.sol/Ballot.json");
  const contractJson = JSON.parse(fs.readFileSync(contractPath, "utf8"));
  
  const factory = new ethers.ContractFactory(contractJson.abi, contractJson.bytecode, wallet);
  const ballot = await factory.deploy(names, ipfsCIDs, duration);
  await ballot.waitForDeployment();

  const address = await ballot.getAddress();
  // console.log("合約部署成功！");
  // console.log("合約地址:", address);
  // console.log("部署錢包地址:", wallet.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    // console.error("部署錯誤:", error.message);
    // console.error(error);
    process.exit(1);
  });
