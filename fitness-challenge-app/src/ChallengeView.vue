<script>
export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            groupId: sessionStorage.getItem('groupId'),
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
    },
    mounted() {
        this.displayChallenges();

        this.currentDate = new Date().toISOString().split('T')[0];
    },
};
</script>

<template>
    <div class="card">
        <h3>Aktive Challenges</h3>

        <div class="challenge" v-for="(data, index) in this.challenges" :key="index">
            <span
                ><b>{{ data.title }}</b></span
            >
            <span>{{ data.description }}</span>
        </div>
        <div class="error-message">{{ this.informationalMessage }}</div>
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
</style>
