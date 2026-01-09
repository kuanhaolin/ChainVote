<script setup>
import { ref } from 'vue'
import greenLogo from './img/green.png'
import blueLogo from './img/blue.png'
import whiteLogo from './img/white.png'
import { store } from './store';
import { ethers } from 'ethers';

const candidates = ref([{ name: 'LIN', votes: 23000000 }, { name: 'KUAN', votes: 15000000 }, { name: 'HAO', votes: 8000000 }]);
const candidateColors = ['#008000', '#0000AA', '#28C8C8'];
const candidateLogos = [greenLogo, blueLogo, whiteLogo];

const getTotalVotes = () => {
    return candidates.value.reduce((sum, c) => sum + c.votes, 0);
}

const getPercentage = (votes) => {
    const total = getTotalVotes();
    return total === 0 ? 0 : Math.round((votes / total) * 100);
}
</script>

<template>
<div class="vote-container">
    <div class="candidates-container">
          <div v-for="(candidate, index) in candidates" :key="index" 
              class="candidate-card"
              :style="{ backgroundColor: candidateColors[index] }">
              <div class="candidate-number">No.{{ index+1 }}</div>
              <div class="candidate-name">{{ candidate.name }}</div>
              <div class="candidate-ticket">
                  <div class="vote-count">{{ candidate.votes.toLocaleString() }} 票</div>
                  <div class="progress-bar">
                      <div class="progress-fill" :style="{ width: getPercentage(candidate.votes) + '%', backgroundColor: candidateColors[index] }"></div>
                  </div>
              </div>
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
.candidate-ticket {
    background-color: white;
    color: #333;
    border: none;
    padding: 40px 10px;
    font-size: 24px;
    font-weight: bold;
    border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    width: 100%;
    /* z-index: 2; */
}
.candidate-ticket:hover {
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
}
.vote-count {
    font-size: 20px;
    text-align: center;
    margin-bottom: 8px;
    white-space: nowrap;
}
.progress-bar {
    width: 80%;
    margin: 0 auto;
    height: 12px;
    background-color: #E0E0E0;
    border-radius: 6px;
    overflow: hidden;
}
.progress-fill {
    height: 100%;
    transition: width 0.5s ease;
    border-radius: 6px;
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
    .candidate-ticket {
        padding: 30px 10px;
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
    .candidate-ticket {
        padding: 20px 10px;
    }
    .vote-count {
        font-size: 16px;
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
    .candidate-logo {
        width: 62px;
        height: 62px;
        bottom: -31px;
        left: -31px;
    }
    .candidate-ticket {
        padding: 20px 0;
    }
}
</style>