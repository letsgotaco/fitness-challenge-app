<script>
export default {
    data() {
        return {
            errorMessage: '',
            userId: sessionStorage.getItem('user_id'),
            groupId: sessionStorage.getItem('groupId'),
            leaderboardData: [],
        };
    },
    methods: {
        async getUser() {
            try {
                const res = await fetch('http://localhost:3000/getUser');

                if (res.ok) {
                    const data = await res.json();
                    return data;
                }
            } catch (error) {
                console.error(error);
                return;
            }
        },
        async getChallenges() {
            try {
                const res = await fetch(
                    `http://localhost:3000/getGroupChallenges/${encodeURIComponent(parseInt(this.groupId))}`,
                );

                if (res.ok) {
                    const data = await res.json();
                    return data;
                }
            } catch (error) {
                console.error(error);
                return;
            }
        },
        async getChallengeParticipants() {
            try {
                const res = await fetch(`http://localhost:3000/getAllChallengeParticipants`);

                if (res.ok) {
                    const data = await res.json();
                    return data;
                }
            } catch (error) {
                console.error(error);
                return;
            }
        },
        async setLeaderboardData() {
            let user = await this.getUser();
            let challenges = await this.getChallenges();
            let challengeParticipants = await this.getChallengeParticipants();

            if (challenges.length === 0) {
                this.errorMessage = 'Es gibt keine Challenge-Teilnehmer!';
            } else {
                for (let i = 0; i < challengeParticipants.length; i++) {
                    let participant = '';
                    let progress = '';
                    let challengename = '';

                    progress = challengeParticipants[i].total_progress;

                    for (let a = 0; a < user.length; a++) {
                        if (challengeParticipants[i].user_id === user[a].user_id) {
                            participant = user[a].username;
                        }
                    }

                    for (let b = 0; b < challenges.length; b++) {
                        if (challengeParticipants[i].challenge_id === challenges[b].challenge_id) {
                            challengename = challenges[b].title;
                        }
                    }

                    if ((participant.length > 0) & (progress.length > 0) & (challengename.length > 0)) {
                        this.leaderboardData.push({
                            participanname: participant,
                            totalProgress: progress,
                            challenge: challengename,
                        });
                    }
                }

                if (this.leaderboardData.length === 0) {
                    this.errorMessage = 'Es gibt keine Challenge-Teilnehmer!';
                } else {
                    this.sortLeaderboardByProgress(this.leaderboardData);
                }
            }
        },
        sortLeaderboardByProgress(data) {
            const sortedLeaderboardData = [...data].sort((a, b) => {
                const progressA = parseFloat(a.totalProgress.replace('%', ''));
                const progressB = parseFloat(b.totalProgress.replace('%', ''));
                return progressB - progressA;
            });

            this.leaderboardData = sortedLeaderboardData;
        },
    },
    mounted() {
        this.setLeaderboardData();
    },
};
</script>

<template>
    <div class="table-container">
        <span class="error-message" v-if="this.errorMessage">{{ this.errorMessage }}</span>

        <div class="table-header" v-if="this.errorMessage.length === 0">
            <span>Teilnehmer</span>
            <span>Fortschritt</span>
            <span>Challenge</span>
        </div>

        <div v-if="this.errorMessage.length === 0">
            <div class="table-row" v-for="(data, index) in this.leaderboardData" :key="index">
                <span>{{ data.participanname }}</span>
                <span>{{ data.totalProgress }}</span>
                <span>{{ data.challenge }}</span>
            </div>
        </div>
    </div>
</template>

<style scoped>
.table-container {
    margin-top: 30px;
    width: 500px;
    background-color: var(--white);
    font-size: var(--font-size-small-text);
    width: 97%;
}

.table-header,
.table-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 20px;
}

.table-header {
    background-color: var(--grey-2);
    font-weight: var(--font-weight-bold);
    border-bottom: 1px solid var(--grey);
}

.table-row {
    border-bottom: 1px solid var(--grey);
}
</style>
