import { createRouter, createWebHistory } from 'vue-router'
import Home from './home.vue'
import Info from './info.vue'
import Vote from './vote.vue'
import Result from './result.vue'
import { store } from './store.js'

const routes = [
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/home',
    name: 'Home',
    component: Home
  },
  {
    path: '/info',
    name: 'Info',
    component: Info
  },
  {
    path: '/vote',
    name: 'Vote',
    component: Vote,
    beforeEnter: (to, from, next) => {
        if (store.isVerified && store.isConnected) {
            next()
        } else {
            alert('請先連接錢包並完成身份驗證！')
            next('/home')
        }
    }
  },
  {
    path: '/result',
    name: 'Result',
    component: Result
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
