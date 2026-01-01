<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios';
import { ethers } from 'ethers';
import * as snarkjs from 'snarkjs';
import greenLogo from './img/green.png'
import blueLogo from './img/blue.png'
import whiteLogo from './img/white.png'

const isVerified = ref(false)
const idCardNumber = ref('')
const healthCardNumber = ref('')
const userAddress = ref('')
const candidates = ref([])
const showVerifyModal = ref(false)
const zkpData = ref(null)

const candidateLogos = [greenLogo, blueLogo, whiteLogo]
const candidateColors = ['#008000', '#0000CD', '#ADD8E6']

const getPercentage = (votes) => {
  const total = candidates.value.reduce((sum, c) => sum + c.votes, 0)
  return total === 0 ? 0 : Math.round((votes / total) * 100)
}

const connectWallet = async () => {
  if (window.ethereum) {
    try {
      await window.ethereum.request({
        method: 'wallet_requestPermissions',
        params: [{ eth_accounts: {} }],
      });
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      userAddress.value = accounts[0] || '';
      isVerified.value = false; // new account must verify again
      showVerifyModal.value = false;
    } catch (error) {
        console.error("User rejected the request:");
      }
  } else {
    alert("Please install MetaMask wallet.");
  }
}

const openVerifyModal = () => {
  if (!userAddress.value) {
    alert("Please connect your wallet first!");
    return;
  }
  showVerifyModal.value = true
}

const closeVerifyModal = () => {
  showVerifyModal.value = false
  idCardNumber.value = ''
  healthCardNumber.value = ''
}

const handleVerify = async () => {
  if (!userAddress.value) {
    alert("Please click the Connect Wallet!!!");
    return;
  }
  if (idCardNumber.value.length === 4 && healthCardNumber.value.length === 4) {
    try{
      const response = await axios.post('http://localhost:3001/api/verify', {
        idCardNumber: idCardNumber.value,
        healthCardNumber: healthCardNumber.value,
      });
      if (response.data.verified) {
        const {root, nullifier, pathElements, pathIndices} = response.data;
        zkpData.value = {root, nullifier, pathElements, pathIndices};
        isVerified.value = true
        showVerifyModal.value = false
        alert('Successful')
      } else {
        alert('Failed')
      }
    }catch (error){
      alert('Server error!!!')
    }
  } else {
    alert('Format error!!!')
}}

const vote = async (candidateIndex) => {
  if (!window.ethereum) return alert("Please connect MetaMask wallet.");
  if (!zkpData.value) return alert("Please verify first!");
  
  try {
    const input = {
      userSecret: idCardNumber.value,
      nullifier: zkpData.value.nullifier,
      candidateIndex: candidateIndex + 1,
      pathElements: zkpData.value.pathElements,
      pathIndices: zkpData.value.pathIndices,
      root: zkpData.value.root
    };
    
    // generate proof
    const {proof, publicSignals} = await snarkjs.groth16.fullProve(
      input,
      "/zk/zkp.wasm",
      "/zk/zkp_final.zkey"
    );

    // convert format
    const callData = await snarkjs.groth16.exportSolidityCallData(proof, publicSignals);
    const argv = JSON.parse("[" + callData + "]");
    
    await voteTocontract(argv);
    alert('Vote successful!')
  } catch (error) {
    alert('Vote failed: ' + error.message)
  }
}

const voteTocontract = async (argv) => {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  const contractAddress = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512';
  const abi = [
    "function vote(uint[2] _proofa, uint[2][2] _proofb, uint[2] _proofc, uint[6] _input) public",
  ];
  const contractWithSigner = new ethers.Contract(contractAddress, abi, signer);
  const tx = await contractWithSigner.vote(
    argv[0],
    argv[1],
    argv[2],
    argv[3]
  );
  await tx.wait();
}

const fetchCandidates = async () => {
  try {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const contractAddress = '0xe7f1725e7734ce288f8367e1bb143e90bb3f0512';
    const abi = [
      "function getCandidates() public view returns((string name, string ipfsCID, uint256 voteCount)[])"
    ];
    const contract = new ethers.Contract(contractAddress, abi, provider);
    const candidateInfo = await contract.getCandidates();
    candidates.value = candidateInfo.map(candidate => ({
      name: candidate.name,
      ipfsCID: candidate.ipfsCID,
      votes: parseInt(candidate.voteCount.toString())
    }));
  } catch (error) {
    alert('Fetch candidates failed!!!')
  }
}

const setupEventListener = async () => {
  if (!window.ethereum) return;
  try {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const contractAddress = '0xe7f1725e7734ce288f8367e1bb143e90bb3f0512';
    const abi = [
      "event Vote(uint256 indexed nullifierHash, uint256 candidate01, uint256 candidate02, uint256 candidate03)"
    ];
    const contract = new ethers.Contract(contractAddress, abi, provider);
    contract.on("Vote", (nullifierHash, candidate01, candidate02, candidate03) => {
      fetchCandidates();
    });
  } catch (error) {
    console.error('Event listener failed:', error.message)
  }
}

// init events
onMounted(() => {
  fetchCandidates();
  setupEventListener()
  
  if (window.ethereum) {
    window.ethereum.on('accountsChanged', (accounts) => {
      userAddress.value = accounts?.[0] || '';
      // isVerified.value = false;
      // showVerifyModal.value = false;
    });
  }
});
</script>

<template>
  <div class="voting-app">
    <div class="main-container">
      <div class="header-banner">
        <h1 class="election-title">烏托邦大選</h1>
        <p class="election-info">1450 / 共產側翼 / 小草</p>
      </div>

      <div class="candidates-container">
        <div v-for="(item, index) in candidates" :key="index" 
             class="candidate-box"
             :style="{ backgroundColor: candidateColors[index] }">
          <div class="candidate-number">No. {{ index + 1 }}</div>
          <div class="candidate-name">{{ item.name }}</div>
          <div class="vote-info-box">
            <button v-if="isVerified" @click="vote(index)" class="vote-btn-inline">Vote</button>
            <div v-else class="vote-count">{{ item.votes }} votes</div>
            <div class="progress-bar-container">
              <div class="progress-bar-fill" 
                   :style="{ width: getPercentage(item.votes) + '%', backgroundColor: candidateColors[index] }">
              </div>
            </div>
          </div>
          <img :src="candidateLogos[index]" class="candidate-logo" :alt="item.name" />
        </div>
      </div>

      <div class="footer-banner">
        <button v-if="!userAddress" @click="connectWallet" class="connect-btn">
          🦊 Connect MetaMask
        </button>
        <button v-else-if="!isVerified" @click="openVerifyModal" class="connect-btn">
          🔑 Verify Identity
        </button>
        <div v-else class="verified-info">
          <span>✓ Verified - Click Vote on candidate card</span>
        </div>
      </div>
    </div>

    <div v-if="showVerifyModal" class="modal-overlay" @click="closeVerifyModal">
      <div class="modal-content" @click.stop>
        <h2 class="modal-title">Identity Verification</h2>
        <div class="modal-form">
          <div class="form-group">
            <label>ID Card Number</label>
            <input v-model="idCardNumber" placeholder="Enter 4 digits" maxlength="4" class="modal-input" />
          </div>
          <div class="form-group">
            <label>Health Card Number (Last 4 digits)</label>
            <input v-model="healthCardNumber" placeholder="Enter 4 digits" maxlength="4" class="modal-input" />
          </div>
          <button @click="handleVerify" class="verify-btn">➜ Submit</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

.voting-app {
  min-height: 100vh;
  background: #F5F5DC;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Microsoft JhengHei', sans-serif;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 0;
}

.main-container {
  max-width: 100%;
  width: 100%;
  min-height: 100vh;
  background: #F5F5DC;
  box-shadow: none;
  overflow: hidden;
}

.header-banner {
  background: #F5F5DC;
  padding: 30px;
  text-align: center;
  border-bottom: none;
}

.election-title {
  font-size: 2.5rem;
  color: #333;
  margin: 0 0 10px 0;
  font-weight: 700;
  letter-spacing: 2px;
}

.election-info {
  color: #555;
  font-size: 1rem;
  margin: 0;
}

.candidates-container {
  display: grid;
  grid-template-columns: repeat(3, minmax(280px, 1fr));
  gap: 50px;
  padding: 40px 180px;
  background: #F5F5DC;
  max-width: 2000px;
  margin: 0 auto;
}

.candidate-box {
  border-radius: 20px;
  padding: 25px 25px 20px;
  margin: 0px;
  position: relative;
  box-shadow: 0 8px 20px rgba(0,0,0,0.15);
  transition: transform 0.3s ease;
}

.candidate-box:hover {
  transform: translateY(-8px);
}

.candidate-number {
  color: white;
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 5px;
  opacity: 0.95;
}

.candidate-name {
  color: white;
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 25px;
  letter-spacing: 3px;
}

.vote-info-box {
  background: white;
  border-radius: 15px;
  padding: 50px;
  margin-bottom: 15px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

.vote-count {
  color: #333;
  font-size: 1.3rem;
  font-weight: 700;
  margin-bottom: 10px;
  text-align: center;
}

.vote-btn-inline {
  width: 100%;
  background: rgba(255, 255, 255, 0.95);
  color: #333;
  border: none;
  padding: 12px;
  font-size: 1.2rem;
  font-weight: 700;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

.vote-btn-inline:hover {
  background: white;
  transform: scale(1.02);
  box-shadow: 0 4px 12px rgba(0,0,0,0.2);
}

.progress-bar-container {
  background: #E0E0E0;
  height: 12px;
  border-radius: 6px;
  overflow: hidden;
}

.progress-bar-fill {
  height: 100%;
  transition: width 0.5s ease;
  border-radius: 6px;
}

.candidate-logo {
  width: 80px;
  height: 80px;
  position: absolute;
  bottom: -25px;
  left: -35px;
  transform: none;
  filter: drop-shadow(0 4px 8px rgba(0,0,0,0.2));
}

.footer-banner {
  background: #F5F5DC;
  padding: 25px;
  text-align: center;
  border-top: none;
}

.connect-btn {
  background: #D4A560;
  color: white;
  border: none;
  padding: 15px 40px;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

.connect-btn:hover {
  background: #C69650;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.3);
}

.verified-info {
  color: #11998e;
  font-size: 1.1rem;
  font-weight: 600;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  animation: fadeIn 0.3s ease;
}

.modal-content {
  background: white;
  border-radius: 20px;
  padding: 40px;
  max-width: 450px;
  width: 90%;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
  animation: slideUp 0.3s ease;
}

.modal-title {
  font-size: 1.8rem;
  color: #333;
  margin: 0 0 30px 0;
  text-align: center;
  font-weight: 700;
}

.modal-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  color: #333;
  font-weight: 600;
  font-size: 0.95rem;
}

.modal-input {
  padding: 14px;
  border: 2px solid #E0E0E0;
  border-radius: 10px;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.modal-input:focus {
  outline: none;
  border-color: #E8B563;
  box-shadow: 0 0 0 3px rgba(232, 181, 99, 0.1);
}

.verify-btn {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  color: white;
  border: none;
  padding: 15px;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 10px;
}

.verify-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(56, 239, 125, 0.4);
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(50px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .election-title {
    font-size: 1.8rem;
  }
  
  .candidates-container {
    grid-template-columns: 1fr;
    padding: 20px 15px;
  }
  
  .candidate-box {
    margin: 10px 0;
  }
  
  .modal-content {
    padding: 30px 20px;
  }
  
  .vote-buttons {
    flex-direction: column;
    gap: 10px;
  }
  
  .footer-vote-btn {
    width: 100%;
  }
}
</style>
