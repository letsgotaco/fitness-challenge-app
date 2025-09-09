<script>
export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            challengeCounter: 0,
        };
    },
    methods: {
        setUserChallengCounter() {
            fetch(`http://localhost:3000/getChallengeCounter/${encodeURIComponent(this.userId)}`)
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    this.challengeCounter = data.count;

                    if (!window.location.hash) {
                        window.location = window.location + '#loaded';
                        window.location.reload();
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        },
    },
    mounted() {
        this.setUserChallengCounter();
    },
};
</script>

<template>
    <div class="dashboard-container">
        <header>
            <nav>
                <h1>Dashboard</h1>
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

        <div class="active-challenges-card">
            <h3>Aktive Challenges:</h3>
            <span class="challenge-counter">{{ this.challengeCounter }}</span>
        </div>

        <div class="groups">
            <!-- To-Do: Set dynamic data -->
            <div class="group">
                <h3>Freunde Laufclub</h3>
                <p>3 aktive Challenges</p>
                <div class="progress-bar">
                    <div class="progress"></div>
                </div>
                <p class="progress-text">Team Fortschritt: 65%</p>
                <button class="group-button">Zur Gruppe</button>
            </div>

            <div class="new-group-card">
                <div>
                    <h3>Neue Gruppe</h3>
                    <p>Erstelle eine private Gruppe</p>
                </div>
                <button class="create-group-button">+ Gruppe erstellen</button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.user-icon {
    margin-top: 15px;
    width: 60px;
    height: 60px;
    cursor: pointer;
}

.challenge-counter {
    font-size: var(--font-size-big-text);
}

.dashboard-container {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

header nav {
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.active-challenges-card {
    background-color: var(--grey-2);
    padding: 20px;
    border-radius: 20px;
    width: fit-content;
}

.groups {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}

.group {
    padding: 20px;
    border-radius: 20px;
    color: var(--white);
    display: flex;
    flex-direction: column;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
}

.progress-bar {
    background-color: var(--grey);
    border-radius: 10px;
    height: 10px;
    margin: 10px 0;
}

.progress {
    background: linear-gradient(to right, var(--light-green-2), var(--light-green));
    height: 100%;
    border-radius: 10px;
    width: 65%;
}

.progress-text {
    color: var(--white);
    font-size: var(--font-size-small-text);
}

.group-button {
    margin-top: auto;
    font-weight: var(--font-weight-bold);
    padding: 10px;
    background-color: var(--grey);
    color: var(--black);
    border: none;
    border-radius: 10px;
    cursor: pointer;
}

.new-group-card {
    background-color: var(--white);
    border: 1px solid var(--grey);
    padding: 20px;
    border-radius: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.create-group-button {
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    border: none;
    padding: 10px;
    color: var(--white);
    font-weight: var(--font-weight-bold);
    border-radius: 10px;
    cursor: pointer;
}
</style>
