<script>
import { split } from 'postcss/lib/list';

export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            badges: [],
            challenges: [],
            name: '',
            textBadges: '',
            textChallenges: '',
        };
    },
    methods: {
        getChallenges() {
            fetch(`http://localhost:3000/getChallenges/${encodeURIComponent(this.userId)}`)
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    let userChallenges = [];
                    for (let i = 0; i < data.length; i++) {
                        userChallenges.push(data[i].challenge_id);
                    }

                    if (data.length === 0) {
                        this.textChallenges = 'Du hast noch keine Challenges abgeschlossen!';
                    } else {
                        fetch(`http://localhost:3000/getAllChallenges`)
                            .then(res => {
                                if (res.ok) {
                                    return res.json();
                                }
                            })
                            .then(data => {
                                for (let a = 0; a < userChallenges.length; a++) {
                                    for (let i = 0; i < data.length; i++) {
                                        if (userChallenges[a] === data[i].challenge_id) {
                                            this.challenges.push({
                                                title: data[i].title,
                                                deadline: data[i].end_date.slice(0, 10),
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
        getUsername() {
            fetch('http://localhost:3000/getUser')
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    for (let i = 0; i < data.length; i++) {
                        if (data[i].user_id === Number(this.userId)) {
                            this.name = data[i].username;
                            break;
                        }
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        },
        getBadges() {
            fetch(`http://localhost:3000/getBadges/${encodeURIComponent(this.userId)}`)
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    let userBadgets = [];
                    for (let i = 0; i < data.length; i++) {
                        userBadgets.push(data[i].badge_id);
                    }

                    if (data.length === 0) {
                        this.textBadges = 'Du hast noch keine Abzeichen!';
                    } else {
                        fetch(`http://localhost:3000/getAllBadges`)
                            .then(res => {
                                if (res.ok) {
                                    return res.json();
                                }
                            })
                            .then(data => {
                                for (let a = 0; a < userBadgets.length; a++) {
                                    for (let i = 0; i < data.length; i++) {
                                        if (userBadgets[a] === data[i].badge_id) {
                                            this.badges.push({ url: data[i].icon_url, name: data[i].name });
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
        this.getBadges();
        this.getChallenges();
        this.getUsername();
    },
};
</script>

<template>
    <div class="profile-container">
        <div class="profile-header">
            <h2>{{ this.name }}</h2>
        </div>

        <div class="section">
            <h3>Abgeschlossene Challenges</h3>
            <span>{{ this.textChallenges }}</span>
            <div class="challenge-row-container">
                <div class="challenge-container" v-for="(data, index) in this.challenges" :key="index">
                    <span>{{ data.title }}</span>
                    <span>Beendet am {{ data.deadline }}</span>
                </div>
            </div>
        </div>

        <div class="section">
            <h3>Badges</h3>
            <div class="badge-row-container">
                <span>{{ this.textBadges }}</span>
                <div v-for="(data, index) in this.badges" :key="index" :src="data" class="badge-container">
                    <img class="badge-image" :src="data.url" />
                    <span>{{ data.name }}</span>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.challenge-container {
    background-color: var(--grey-2);
    width: 600px;
    padding: 20px;
    border-radius: 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.badge-row-container,
.challenge-row-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    padding-top: 20px;
}

.badge-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-text);
}

.badge-image {
    width: 100px;
    margin-bottom: 10px;
}

.profile-container {
    background-color: var(--white);
    margin-top: 30px;
}

.profile-header {
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    padding: 20px;
    font-size: var(--font-size-big-text);
    border-radius: 20px;
}

.section {
    padding: 20px;
}
</style>
