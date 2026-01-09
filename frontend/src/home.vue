<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { store } from './store.js'

const idCardNumber = ref('')
const healthCardNumber = ref('')
const showVerify = ref(false)

const openVerify = () => {
    // if (!userAddress.value) {
    //     alert('請先連接錢包!');
    //     return;
    // }   
    showVerify.value = true;
}

const closeVerify = () => {
    showVerify.value = false
    idCardNumber.value = ''
    healthCardNumber.value = ''
}

const handleVerify = async () => {
    if (idCardNumber.value.length !== 4 || healthCardNumber.value.length !== 4) {
        alert('請輸入正確的資訊!');
        return;
    }
    try {
        const response = await axios.post('http://localhost:3001/api/verify', {
            idCardNumber: idCardNumber.value,
            healthCardNumber: healthCardNumber.value
        });
        if (response.data.verified) {
            const {root, nullifier, pathElements, pathIndices, pk} = response.data;
            store.zkpData = {root, nullifier, pathElements, pathIndices, pk};
            store.userSecret = idCardNumber.value;
            store.isVerified = true;
            showVerify.value = false;
            alert('身份驗證成功!');
        } else {
            alert('身份驗證失敗!')
            console.log(idCardNumber.value, healthCardNumber.value);
        }
    } catch (error) {
        alert('驗證過程錯誤!')
    }
}

const disconnectVerify = () => {
    store.isVerified = false;
    store.zkpData = null;
    store.userSecret = null;
    alert('驗證已斷開')
}

const connectWallet = async () => {
    if (window.ethereum) {
        try {
            const accounts = await window.ethereum.request({ 
                method: 'eth_requestAccounts' 
            })
            store.userAddress = accounts[0]
            store.isConnected = true
            alert('錢包連接成功！')
        } catch (error) {
            console.error('連接失敗:', error)
            if (error.code === 4001) {
                alert('您拒絕了連接請求')
            } else {
                alert('連接錢包失敗，請重試')
            }
        }
    } else {
        alert('請先安裝 MetaMask 錢包!')
        window.open('https://metamask.io/download/', '_blank')
    }
}

const disconnectWallet = () => {
    store.userAddress = ''
    store.isConnected = false
    alert('錢包已斷開')
}

if (window.ethereum) {
    window.ethereum.on('accountsChanged', (accounts) => {
        if (accounts.length === 0) {
            store.userAddress = ''
            store.isConnected = false
        } else {
            store.userAddress = accounts[0]
            store.isConnected = true
        }
    })
}
</script>

<template>
<div>
    <div class="container">
        <div class="hero">
            <div class="hero-content">
                <h1 class="hero-title">歡迎烏托邦選舉</h1>
                <p class="hero-description">
                    烏托邦選舉烏托邦選舉烏托邦選舉<br>
                    烏托邦選舉烏托邦選舉烏托邦選舉<br>
                    烏托邦選舉烏托邦選舉烏托邦選舉<br>
                    烏托邦選舉烏托邦選舉烏托邦選舉<br>
                    烏托邦選舉烏托邦選舉烏托邦選舉<br>                        
                    烏托邦選舉烏托邦選舉
                </p>
                <div class="hero-buttons">
                    <button v-if="!store.isConnected" @click="connectWallet" class="btn btn-primary">🦊 連接錢包</button>
                    <button v-else @click="disconnectWallet" class="btn btn-primary">⛓️‍💥 斷開錢包</button>
                    <button v-if="!store.isVerified" @click="openVerify" class="btn btn-secondary">ℹ️ 驗證身份</button>
                    <button v-else @click="disconnectVerify" class="btn btn-secondary">⛓️‍💥 取消驗證</button>
                    <!-- <router-link to="/vote" class="btn btn-secondary">🗳️ 前往投票</router-link> -->
                </div>
            </div>
        </div>
    </div>

    <div v-if="showVerify" class="modal-overlay" @click="closeVerify">
      <div class="modal-content" @click.stop>
        <h2 class="modal-title">身份驗證</h2>
        <div class="modal-form">
          <div class="form-group">
            <label>身份證號碼</label>
            <input v-model="idCardNumber" placeholder="輸入4位數字" maxlength="4" class="modal-input" />
          </div>
          <div class="form-group">
            <label>健保卡號碼(後四碼)</label>
            <input v-model="healthCardNumber" placeholder="輸入4位數字" maxlength="4" class="modal-input" />
          </div>
          <button @click="handleVerify" class="verify-btn">提交</button>
        </div>
      </div>
    </div>

    <!-- <div class="footer">
      <p>© 2025 ChainVote. All rights reserved.</p>
    </div> -->
</div>
</template>

<style scoped>
.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 30px 30px;
}
.hero {
    display: flex;
    /* justify-content: flex-start; */
    /* align-items: flex-start; */
    margin: 10px 70px;
    min-height: 60vh;
}
.hero-content {
    max-width: 700px;
}
.hero-title {
    font-size: 48px;
    font-weight: bold;
    margin-bottom: 30px;
    color: #000;
}
.hero-description {
    font-size: 16px;
    line-height: 1.8;
    color: #666;
    margin-bottom: 40px;
    letter-spacing: 0.5px;
}
.hero-buttons {
    display: flex;
    gap: 20px;
    
}
.wallet-info {
    background-color: #E8F5E9;
    padding: 15px 20px;
    border-radius: 10px;
    margin-bottom: 20px;
}
.wallet-info p {
    color: #2E7D32;
    font-weight: 600;
    margin: 0;
}
.btn {
    padding: 15px 30px;
    font-size: 16px;
    /* border: none; */
    border-radius: 25px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-weight: 500;
    text-decoration: none;
    display: inline-block;
    
}
.btn-primary {
    border: 1px solid #ADADAD;
    background-color: #F5DEB3;
    color: #333;
}
.btn-primary:hover {
    background-color: #E6CF9F;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(245, 222, 179, 0.4);
}
.btn-secondary {
    border: 1px solid #A0A0A0;
    background-color: #E8E8E8;
    color: #333;
}
.btn-secondary:hover {
    background-color: #D0D0D0;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
.footer {
    text-align: center;
    padding: 20px;
    font-size: 14px;
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
    /* gap: 8px; */
}
.form-group label {
    color: #333;
    font-weight: 600;
    font-size: 0.95rem;
}
.modal-input {
    padding: 14px;
    border: 2px solid hsl(0, 0%, 88%);
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

@media (max-width: 1024px) {
    .container {
        padding: 0px 20px;
    }
    .hero {
        margin: 40px 80px;
    }
    .hero-title {
        font-size: 40px;
    }
}

@media (max-width: 768px) {
    .container {
        padding: 30px 20px;
    }
    .hero {
        margin: 0px 60px;
    }
    .hero-title {
        font-size: 32px;
    }
    .hero-description {
        font-size: 14px;
    }
    .hero-buttons {
        flex-direction: column;
        width: 100%;
    }
    .btn {
        width: 100%;
    }
}

@media (max-width: 480px) {
    .hero {
        margin: 0px 10px;
    }
    .hero-title {
        font-size: 28px;
    }

    .btn {
        padding: 12px 24px;
        font-size: 14px;
    }
    .modal-content {
        padding: 40px;
        max-width: 250px;
        width: 90%;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        animation: slideUp 0.3s ease;
    }

}
</style>