<script>
import Leaderboard from './Leaderboard.vue';
import NewsFeed from './NewsFeed.vue';
import ChallengeView from './ChallengeView.vue';

export default {
    data() {
        return {
            groupname: sessionStorage.getItem('groupname'),
            showLeaderboard: false,
            showNewsFeed: true,
            showChallenges: false,
        };
    },
    components: {
        Leaderboard,
        NewsFeed,
        ChallengeView,
    },
    methods: {
        displayLeaderboard(event) {
            this.removeActiveClass();
            event.target.classList.add('active-tab-button');

            this.showLeaderboard = true;
            this.showChallenges = false;
            this.showNewsFeed = false;
        },
        displayNewsFeed(event) {
            this.removeActiveClass();
            event.target.classList.add('active-tab-button');

            this.showLeaderboard = false;
            this.showChallenges = false;
            this.showNewsFeed = true;
        },
        displayChallenges(event) {
            this.removeActiveClass();
            event.target.classList.add('active-tab-button');

            this.showLeaderboard = false;
            this.showChallenges = true;
            this.showNewsFeed = false;
        },
        removeActiveClass() {
            let newsFeedButton = this.$refs.button;
            let challengesButton = this.$refs.button1;
            let leaderboardButton = this.$refs.button2;

            newsFeedButton.classList.remove('active-tab-button');
            challengesButton.classList.remove('active-tab-button');
            leaderboardButton.classList.remove('active-tab-button');
        },
    },
};
</script>

<template>
    <header>
        <nav>
            <h1>{{ this.groupname }}</h1>
            <router-link to="/profile">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" class="user-icon">
                    <defs>
                        <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" style="stop-color: #4facfe; stop-opacity: 1" />
                            <stop offset="100%" style="stop-color: #00f2fe; stop-opacity: 1" />
                        </linearGradient>
                    </defs>
                    <circle cx="64" cy="64" r="64" fill="url(#grad)" />
                    <circle cx="64" cy="40" r="20" fill="white" />
                    <path d="M32 96c0-17.67 14.33-32 32-32s32 14.33 32 32H32z" fill="white" />
                </svg>
            </router-link>
        </nav>
    </header>

    <div class="tab-container">
        <button ref="button" class="tab-button active-tab-button" @click="displayNewsFeed">Feed</button>
        <button ref="button1" class="tab-button" @click="displayChallenges">Challenges</button>
        <button ref="button2" class="tab-button" @click="displayLeaderboard">Leaderboard</button>
    </div>

    <ChallengeView v-if="this.showChallenges"></ChallengeView>
    <NewsFeed v-if="this.showNewsFeed"></NewsFeed>
    <Leaderboard v-if="this.showLeaderboard"></Leaderboard>
</template>

<style scoped>
.tab-container {
    display: flex;
    gap: 20px;
    margin-top: 30px;
}

.tab-button {
    padding: 10px 14px;
    border-radius: 9999px;
    border: none;
    font-size: 1rem;
    font-weight: 500;
    cursor: pointer;
    background: var(--grey);
    transition: background 0.3s;
}

.active-tab-button {
    background: linear-gradient(90deg, var(--light-blue), var(--light-blue-2));
    color: var(--white);
}
</style>
