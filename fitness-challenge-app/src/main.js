import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import bcrypt from 'bcryptjs';

const app = createApp(App);

app.use(router);

// global functions
app.config.globalProperties.$hashPassword = async (plainPassword, saltRounds = 10) => {
    try {
        return await bcrypt.hash(plainPassword, saltRounds);
    } catch (err) {
        console.error('Fehler beim Hashen:', err);
        throw err;
    }
};

app.mount('#app');
