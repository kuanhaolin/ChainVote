<script setup>
import { ref } from 'vue'
import greenLogo from './img/green.png'
import blueLogo from './img/blue.png'
import whiteLogo from './img/white.png'
import { store } from './store';
import * as snarkjs from 'snarkjs';
import { ethers } from 'ethers';

const candidates = ref([{ name: 'LIN' }, { name: 'KUAN' }, { name: 'HAO' }]);
const candidateColors = ['#008000', '#0000AA', '#28C8C8'];
const candidateLogos = [greenLogo, blueLogo, whiteLogo];

const getRandomBigInt = () => {
    return BigInt(Math.floor(Math.random() * 10**12)).toString();
}

const vote = async (index) => {
    try {
        const r1 = getRandomBigInt();
        const r2 = getRandomBigInt();
        const r3 = getRandomBigInt();
        const input = {
            userSecret: store.userSecret,
            nullifier: store.zkpData.nullifier,
            candidateIndex: (index+1).toString(),
            pathElements: store.zkpData.pathElements,
            pathIndices: store.zkpData.pathIndices,
            root: store.zkpData.root,
            r: [r1, r2, r3],
            pk: store.zkpData.pk
        };
        //generate proof
        const {proof, publicSignals} = await snarkjs.groth16.fullProve(
            input,
            '/zk/zkp.wasm',
            '/zk/zkp_final.zkey'
        );

        //convert format
        const callData = await snarkjs.groth16.exportSolidityCallData(proof, publicSignals);
        const argv = JSON.parse("[" + callData + "]"); 
        await voteTocontract(argv);

        alert('成功投票給 No.${index+1}');
    } catch (error) {
        alert('投票過程中發生錯誤!');
    }
}

const voteTocontract = async (argv) => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contractAddress = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512'; // local hardhat
    const abi = [
        "function vote(uint[2] _proofa, uint[2][2] _proofb, uint[2] _proofc, uint[17] _input) public"
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
</script>

<template>
<div class="vote-container">
    <div class="candidates-container">
          <div v-for="(candidate, index) in candidates" :key="index" 
              class="candidate-card"
              :style="{ backgroundColor: candidateColors[index] }">
              <div class="candidate-number">No.{{ index + 1 }}</div>
              <div class="candidate-name">{{ candidate.name }}</div>
              <button class="vote-btn" @click="vote(index)">投票</button>
              <img :src="candidateLogos[index]" class="candidate-logo" :alt="`Candidate ${index + 1}`" />
          </div>
    </div>
</div>
</template>

<style scoped>
.vote-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 80px 40px;
}
.candidates-container {
    display: flex;
    justify-content: center;
    gap: 120px;
    flex-wrap: wrap;
}
.candidate-card {
    width: 210px;
    height: 280px;
    border-radius: 30px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    position: relative;
    padding: 40px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    transition: transform 0.3s ease;
}
.candidate-card:hover {
    transform: translateY(-8px);
}
.candidate-number {
    font-size: 32px;
    font-weight: bold;
    color: white;
}
.candidate-name {
    font-size: 32px;
    font-weight: bold;
    color: white;
    margin-bottom: 40px;
    letter-spacing: 4px;
}
.vote-btn {
    background-color: white;
    color: #333;
    border: none;
    padding: 40px 80px;
    font-size: 24px;
    font-weight: bold;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    z-index: 2;
}
.vote-btn:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
}
.candidate-logo {
    position: absolute;
    bottom: -40px;
    left: -40px;
    width: 80px;
    height: 80px;
    object-fit: contain;
}

@media (max-width: 1024px) {
    .candidates-container {
        gap: 50px;
    }
    .candidate-card {
        width: 150px;
        height: 220px;
        padding: 40px 30px;
    }
    .candidate-name {
        font-size: 32px;
    }
    .vote-btn {
        padding: 30px 50px;
        font-size: 22px;
    }
}

@media (max-width: 768px) {
    .vote-container {
        margin: 0 auto;
        padding: 40px 20px;
    }
    .candidates-container {
        gap: 60px;
    }
    .candidate-card {
        width: 120px;
        height: 150px;
    }
    .candidate-number {
        font-size: 26px;
    }
    .candidate-name {
        font-size: 26px;
        letter-spacing: 4px;
        margin-bottom: 30px;
    }
    .vote-btn {
        padding: 20px 40px;
        font-size: 20px;
    }
    .candidate-logo {
        width: 70px;
        height: 70px;
        bottom: -35px;
        left: -35px;
    }
}

@media (max-width: 480px) {
    .vote-container {
        padding: 20px 20px;
    }
    .candidates-container {
        flex-direction: column;
        align-items: center;
        gap: 40px;
    }
    .candidate-card {
        width: 160px;
        height: 180px;
        padding: 20px 20px;
    }
    .candidate-number {
        font-size: 24px;
    }
    .candidate-name {
        font-size: 24px;
        letter-spacing: 3px;
        margin-bottom: 30px;
    }
    .vote-btn {
        padding: 20px 40px;
        font-size: 20px;
    }
    .candidate-logo {
        width: 62px;
        height: 62px;
        bottom: -31px;
        left: -31px;
    }
}
</style>