<script>
export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            groupId: sessionStorage.getItem('groupId'),
            currentChallengeId: 0,
            currentChallengeName: '',
            currentChallengeDescription: '',
            correctInput: true,
            informationalMessage: '',
            errorMessage: '',
            successMessage: '',
            challengeTitle: '',
            challengeDescription: '',
            challengeGoal: '',
            deadline: '',
            challenges: [],
            currentDate: '',
            showProgressForm: false,
            progress: '',
            correctInputProgressForm: true,
            errorMessageProgressForm: '',
            successMessageProgressForm: '',
        };
    },
    methods: {
        validateUserInput() {
            if (
                this.challengeTitle.length === 0 ||
                this.challengeDescription.length === 0 ||
                this.challengeGoal.length === 0 ||
                this.deadline.length === 0
            ) {
                this.errorMessage = 'Bitte fülle alle Felder aus!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }
        },
        createNewChallenge() {
            this.validateUserInput();

            if (this.correctInput) {
                fetch('http://localhost:3000/createChallenge', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        group_id: this.groupId,
                        title: this.challengeTitle,
                        description: this.challengeDescription,
                        target: this.challengeGoal,
                        end_date: this.deadline,
                        created_by: this.userId,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessage = 'Challenge erfolgreich erstellt!';
                            this.displayChallenges();
                            return res.json();
                        }
                    })
                    .catch(error => {
                        console.error('Fehler:', error);
                    });
            }
        },
        displayChallenges() {
            fetch(`http://localhost:3000/getGroupChallenges/${encodeURIComponent(parseInt(this.groupId))}`)
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    if (data.length === 0) {
                        this.informationalMessage = 'Keine Challenges verfügbar!';
                    } else {
                        this.challenges = data;
                        this.informationalMessage = '';
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        },
        async toggleProgressForm(event) {
            this.showProgressForm = !this.showProgressForm;
            this.currentChallengeId = event.target.id;
            this.currentChallengeName = event.target.dataset.challengename;
            this.currentChallengeDescription = event.target.dataset.challengedescription;

            if (this.showProgressForm) {
                let totalUserProgress = await this.CheckUserProgress();

                if (totalUserProgress === '100%') {
                    this.$refs.saveProgressButton.disabled = true;
                }
            }
        },
        validateUserInputProgressForm() {
            const regExpPercentage = /^(100([.,]0+)?|(\d{1,2}([.,]\d+)?))%$/;

            if (this.progress.length === 0) {
                this.errorMessageProgressForm = 'Bitte fülle alle Felder aus!';
                this.correctInputProgressForm = false;
                return;
            } else if (!this.progress.match(regExpPercentage)) {
                this.errorMessageProgressForm = 'Gebe bitte einen Prozentwert an!';
                this.correctInputProgressForm = false;
                return;
            } else {
                this.correctInputProgressForm = true;
                this.errorMessageProgressForm = '';
            }
        },
        async saveChallengeProgress() {
            this.validateUserInputProgressForm();

            if (this.correctInputProgressForm) {
                fetch('http://localhost:3000/addProgress', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        challenge_id: this.currentChallengeId,
                        user_id: this.userId,
                        total_progress: this.progress,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessageProgressForm = 'Fortschritt gespeichert!';
                        }
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }

            if (this.progress === '100%') {
                // Create new Badge for challenge, if it doesnt exist
                fetch('http://localhost:3000/createBadge', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        name: this.currentChallengeName,
                        description: this.currentChallengeDescription,
                        icon_url: 'https://cdn-icons-png.flaticon.com/512/5182/5182773.png',
                    }),
                }).catch(error => {
                    console.error(error);
                });

                let badgeId = await this.getBadgeId();

                fetch('http://localhost:3000/createUserBadge', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        user_id: this.userId,
                        badge_id: badgeId,
                    }),
                }).catch(error => {
                    console.error(error);
                });
            }
        },
        async CheckUserProgress() {
            try {
                const res = await fetch(
                    `http://localhost:3000/getUserProgress/${encodeURIComponent(this.userId)}/${encodeURIComponent(this.currentChallengeId)}`,
                );

                const data = await res.json();
                if (data.length > 0) {
                    return data[0].total_progress;
                }
            } catch (error) {
                console.error(error);
                return;
            }
        },

        async getBadgeId() {
            try {
                const res = await fetch(
                    `http://localhost:3000/getSpecificBadgeId/${encodeURIComponent(this.currentChallengeName)}`,
                );

                const data = await res.json();
                return data[0].badge_id;
            } catch (error) {
                console.error(error);
                return;
            }
        },
    },
    mounted() {
        this.displayChallenges();

        this.currentDate = new Date().toISOString().split('T')[0];
    },
};
</script>

<template>
    <div class="card">
        <div>
            <h3>Aktive Challenges</h3>

            <div
                class="challenge"
                v-for="(data, index) in this.challenges"
                :key="index"
                @click="toggleProgressForm"
                :id="data.challenge_id"
                :data-challengeName="data.title"
                :data-challengeDescription="data.description"
            >
                <span class="no-pointer-events"
                    ><b>{{ data.title }}</b></span
                >
                <span class="no-pointer-events">{{ data.description }}</span>
                <span class="no-pointer-events">Endet am {{ data.end_date.slice(0, 10) }}</span>
            </div>
            <div class="error-message">{{ this.informationalMessage }}</div>
        </div>
        <div v-if="this.showProgressForm">
            <form>
                <h3>Fortschritt eintragen</h3>

                <label for="progress">Fortschritt</label>
                <input type="text" id="progress" name="progress" v-model="this.progress" />

                <button ref="saveProgressButton" type="button" @click="saveChallengeProgress">
                    Speichern
                </button>

                <div class="error-message">{{ this.errorMessageProgressForm }}</div>
                <div class="success-message">{{ this.successMessageProgressForm }}</div>
            </form>
        </div>
    </div>

    <form>
        <h3>Neue Challenge erstellen</h3>

        <label for="title">Titel</label>
        <input type="text" id="title" name="title" v-model="this.challengeTitle" />

        <label for="description">Beschreibung</label>
        <textarea id="description" name="description" rows="3" v-model="this.challengeDescription"></textarea>

        <label for="goal">Ziel</label>
        <input type="text" id="goal" name="goal" v-model="this.challengeGoal" />

        <label for="date">Enddatum</label>
        <input type="date" id="date" name="date" :min="this.currentDate" v-model="this.deadline" />

        <button type="button" @click="createNewChallenge">Erstellen</button>

        <div class="error-message">{{ this.errorMessage }}</div>
        <div class="success-message">{{ this.successMessage }}</div>
    </form>
</template>

<style scoped>
.card {
    display: flex;
    align-items: center;
    cursor: pointer;
    margin-top: 30px;
    background: var(--white);
    border-radius: 12px;
    padding: 16px;
    max-width: 350px;
}

.challenge {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    gap: 15px;
    border-radius: 20px;
    padding: 12px;
    margin-bottom: 12px;
    border: 1px solid var(--grey);
    width: fit-content;
    margin-top: 20px;
}

form {
    background: var(--white);
    padding: 16px;
    border-radius: 20px;
    max-width: 350px;
}

label {
    display: block;
    margin: 10px 0 5px;
}

input,
textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid var(--grey);
    border-radius: 8px;
    font-size: var(--font-size-small-text);
}

button {
    padding: 10px 15px;
    border: none;
    border-radius: 8px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    font-size: var(--font-size-small-text);
    cursor: pointer;
    margin-top: 15px;
}

button:disabled {
    background: var(--grey);
    cursor: not-allowed;
}
</style>
