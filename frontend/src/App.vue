<script setup>
import { ref } from 'vue'

const isMenuOpen = ref(false)

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value
}

const closeMenu = () => {
  isMenuOpen.value = false
}
</script>

<template>
  <div>
    <div class="navbar">
      <div class="navbar-title">
        <span class="logo-v">V</span><span class="logo-text">ChainVote</span>
      </div>
      <button 
        class="hamburger" 
        :class="{ active: isMenuOpen }"
        @click="toggleMenu">
        <span></span>
        <span></span>
        <span></span>
      </button>
      <div class="menu" :class="{ active: isMenuOpen }">
        <router-link to="/home" class="menu-item" @click="closeMenu">首頁</router-link>
        <router-link to="/info" class="menu-item" @click="closeMenu">資訊</router-link>
        <router-link to="/vote" class="menu-item" @click="closeMenu">投票</router-link>
        <router-link to="/result" class="menu-item" @click="closeMenu">結果</router-link>
      </div>
      <div class="search">
        <button class="search-btn">🔍</button>
      </div>
    </div>

    <router-view></router-view>
  </div>
</template>

<style scoped>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 40px 100px;
    padding: 10px 40px;
    border-radius: 50px;
    background-color: #F4F1F1;
    border: 1px solid #AEAEAE;
}

.navbar-title {
    display: flex;
    align-items: baseline;
    gap: 5px;
}

.logo-v {
    font-size: 28px;
    font-weight: bold;
}

.logo-text {
    font-size: 12px;
}

.menu {
    display: flex;
    gap: 60px;
    align-items: center;
}

.menu-item {
    cursor: pointer;
    font-size: 16px;
    transition: all 0.3s ease;
    padding: 8px 20px;
    border-radius: 20px;
    text-decoration: none;
    color: #333;
    display: inline-block;
}

.menu-item.active,
.menu-item.router-link-active {
    background-color: #F5F5F5;
    border: 1px solid #D2D2D2;
    color: #333;
}

.menu-item:hover {
    color: #333;
    background-color: #E8E8E8;
}

.hamburger {
    display: none;
    flex-direction: column;
    gap: 5px;
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px;
}

.hamburger span {
    width: 25px;
    height: 3px;
    background-color: #333;
    transition: all 0.3s ease;
    border-radius: 2px;
}

.hamburger.active span:nth-child(1) {
    transform: rotate(45deg) translate(8px, 8px);
}

.hamburger.active span:nth-child(2) {
    opacity: 0;
}

.hamburger.active span:nth-child(3) {
    transform: rotate(-45deg) translate(7px, -7px);
}

.search-btn {
    cursor: pointer;
    font-size: 16px;
    padding: 8px 20px;
    border-radius: 20px;
    background-color: #D5D8D5;
    opacity: 0.7;
    transition: opacity 0.3s ease;
    border: none;
}

.search-btn:hover {
    opacity: 1;
}

@media (max-width: 1024px) {
    .navbar {
        margin: 40px 100px;
        border-radius: 50px;
    }

    .menu {
        gap: 30px;
    }

    .menu-item {
        font-size: 14px;
        padding: 6px 14px;
    }
}

@media (max-width: 768px) {
    .navbar {
        flex-wrap: nowrap;
        margin: 40px 80px;
        border-radius: 50px;
        gap: 15px;
        position: relative;
    }

    .hamburger {
        display: flex;
        order: 2;
    }

    .navbar-title {
        order: 1;
    }

    .search {
        order: 3;
    }

    .menu {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background-color: #F4F1F1;
        flex-direction: column;
        gap: 0;
        margin-top: 15px;
        border-radius: 20px;
        padding: 10px 0;
        max-height: 0;
        overflow: hidden;
        opacity: 0;
        transition: all 0.3s ease;
        order: 4;
        width: 100%;
        z-index: 1000;
    }

    .menu.active {
        max-height: 300px;
        opacity: 1;
        padding: 15px 0;
    }

    .menu-item {
        width: 100%;
        text-align: center;
        padding: 12px 20px;
        border-radius: 0;
    }

    .navbar-title {
        width: auto;
        justify-content: flex-start;
    }

    .search {
        display: none;
    }
}

@media (max-width: 480px) {
    .navbar {
        margin: 20px 5px;
        padding: 5px 20px;
        border-radius: 50px;
    }

    .logo-v {
        font-size: 20px;
    }

    .logo-text {
        font-size: 8px;
    }

    .menu {
        gap: 10px;
    }

    .menu-item {
        font-size: 13px;
        padding: 5px 10px;
    }
}
</style>
