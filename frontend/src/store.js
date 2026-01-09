import { reactive } from 'vue'

export const store = reactive({
    userAddress: '',
    isConnected: false,
    isVerified: false,
    zkpData: null,
    userSecret: null
})
