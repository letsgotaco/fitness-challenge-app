import { createRouter, createWebHistory } from 'vue-router';
import ChallengeView from '@/ChallengeView.vue';
import Dashboard from '@/Dashboard.vue';
import GroupView from '@/GroupView.vue';
import Leaderboard from '@/Leaderboard.vue';
import NewsFeed from '@/NewsFeed.vue';
import Profile from '@/Profile.vue';
import Login from '@/Login.vue';

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            component: Login,
        },
        {
            path: '/challenges',
            component: ChallengeView,
        },
        {
            path: '/dashboard',
            component: Dashboard,
        },
        {
            path: '/group',
            component: GroupView,
        },
        {
            path: '/leaderboard',
            component: Leaderboard,
        },
        {
            path: '/login',
            component: Login,
        },
        {
            path: '/news-Feed',
            component: NewsFeed,
        },
        {
            path: '/profile',
            component: Profile,
        },
    ],
});

export default router;
