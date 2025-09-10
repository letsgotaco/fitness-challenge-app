<script>
export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            challengeCounter: 0,
            textPrivateGroups: '',
            textPrivateGroups2: '',
            groups: [],
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
        setGroupname(event) {
            sessionStorage.setItem('groupname', event.target.id);

            this.$router.push('/group');
        },
        displayPrivateGroups() {
            fetch(`http://localhost:3000/getPrivateGroups/${encodeURIComponent(this.userId)}`)
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    let userGroups = [];
                    for (let i = 0; i < data.length; i++) {
                        userGroups.push(data[i].group_id);
                    }

                    if (data.length === 0) {
                        this.textPrivateGroups = 'Keine Gruppen gefunden!';
                        this.textPrivateGroups2 =
                            'Du bist aktuell in keiner privaten Gruppe. Damit hier deine privaten Gruppen auftauchen, musst du nur eine erstellen oder dich in eine andere Gruppe einladen lassen.';
                    } else {
                        fetch(`http://localhost:3000/getAllGroups`)
                            .then(res => {
                                if (res.ok) {
                                    return res.json();
                                }
                            })
                            .then(data => {
                                for (let a = 0; a < userGroups.length; a++) {
                                    for (let i = 0; i < data.length; i++) {
                                        if (userGroups[a] === data[i].group_id) {
                                            this.groups.push({
                                                name: data[i].name,
                                                description: data[i].description,
                                            });
                                        }
                                    }
                                }
                            })
                            .catch(error => {
                                console.error(error);
                            });
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        },
    },
    mounted() {
        this.setUserChallengCounter();
        this.displayPrivateGroups();
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
            <div class="no-group-found-container group" v-if="this.textPrivateGroups.length > 0">
                <h3>{{ this.textPrivateGroups }}</h3>
                <span>{{ this.textPrivateGroups2 }}</span>
            </div>
            <div class="group" v-for="(data, index) in this.groups" :key="index">
                <h3>{{ data.name }}</h3>
                <span>{{ data.description }}</span>

                <!-- id is used to set groupname in groupview component. DO NOT REMOVE -->
                <button class="group-button" :id="data.name" @click="setGroupname">Zur Gruppe</button>
            </div>

            <div class="new-group-card">
                <h3>Neue Gruppe</h3>
                <span>Erstelle eine private Gruppe</span>
                <button class="create-group-button">+ Gruppe erstellen</button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.challenge-counter {
    font-size: var(--font-size-big-text);
}

.dashboard-container {
    display: flex;
    flex-direction: column;
    gap: 20px;
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
    justify-content: space-between;
    gap: 15px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    font-size: var(--font-size-small-text);
}

.no-group-found-container {
    width: 350px;
}

.group-button {
    font-weight: var(--font-weight-bold);
    padding: 10px;
    background-color: var(--grey);
    color: var(--black);
    border: none;
    border-radius: 10px;
    cursor: pointer;
    font-size: var(--font-size-small-text);
    text-align: center;
    text-decoration: none;
}

.new-group-card {
    background-color: var(--white);
    border: 1px solid var(--grey);
    padding: 20px;
    border-radius: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    gap: 15px;
}

.create-group-button {
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    border: none;
    padding: 10px;
    color: var(--white);
    font-size: var(--font-size-small-text);
    font-weight: var(--font-weight-bold);
    border-radius: 10px;
    cursor: pointer;
}
</style>
