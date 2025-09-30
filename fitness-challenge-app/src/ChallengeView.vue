<script>
export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            groupId: sessionStorage.getItem('groupId'),
            currentChallengeId: 0,
            currentChallengeName: '',
            currentChallengeDescription: '',
            currentChallengeGoal: '',
            correctInput: true,
            informationalMessage: '',
            errorMessageCreateChallengeForm: '',
            successMessageCreateChallengeForm: '',
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
            showPopUpEditChallengeForm: false,
            newChallengeTitle: '',
            newChallengeDescription: '',
            newDeadline: '',
            newChallengeGoal: '',
            correctInput2: true,
            errorMessageEditChallengeForm: '',
            successMessageEditChallengeForm: '',
            editedChallengeId: 0,
        };
    },
    methods: {
        validateUserInputCreateChallengeForm() {
            if (this.challengeTitle.length === 0) {
                this.errorMessageCreateChallengeForm = 'Bitte fülle den Titel aus!';
                this.correctInput = false;
                return;
            }
            if (this.challengeDescription.length === 0) {
                this.errorMessageCreateChallengeForm = 'Bitte fülle die Beschreibung aus!';
                this.correctInput = false;
                return;
            }
            if (this.challengeGoal.length === 0) {
                this.errorMessageCreateChallengeForm = 'Bitte fülle das Ziel aus!';
                this.correctInput = false;
                return;
            } else if (!this.challengeGoal.match(/^-?\d+(\.\d+)?$/) || parseFloat(this.challengeGoal) <= 0) {
                this.errorMessageCreateChallengeForm = 'Gebe bitte eine positive Zahl als Ziel an!';
                this.correctInput = false;
                return;
            }
            if (this.deadline.length === 0) {
                this.errorMessageCreateChallengeForm = 'Bitte wähle ein Enddatum aus!';
                this.correctInput = false;
                return;
            }
            this.correctInput = true;
            this.errorMessageCreateChallengeForm = '';
        },
        createNewChallenge() {
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
                        this.successMessageCreateChallengeForm = 'Challenge erfolgreich erstellt!';
                        this.displayChallenges();
                        // Clear form fields
                        this.challengeTitle = '';
                        this.challengeDescription = '';
                        this.challengeGoal = '';
                        this.deadline = '';
                        return res.json();
                    } else {
                        this.errorMessageCreateChallengeForm = 'Fehler beim Erstellen der Challenge!';
                    }
                })
                .catch(error => {
                    console.error('Fehler:', error);
                    this.errorMessageCreateChallengeForm = 'Netzwerkfehler!';
                });
        },
        async displayChallenges() {
            // Reset Array to not display challenges twice
            this.challenges = [];

            try {
                const res = await fetch(
                    `http://localhost:3000/getGroupChallenges/${encodeURIComponent(parseInt(this.groupId))}`,
                );
                if (res.ok) {
                    const data = await res.json();
                    if (data.length === 0) {
                        this.informationalMessage = 'Keine Challenges verfügbar!';
                    } else {
                        this.challenges = data;
                        this.informationalMessage = '';
                        // Add progress to each challenge
                        for (let i = 0; i < this.challenges.length; i++) {
                            const progress = await this.getUserProgressForChallenge(
                                this.challenges[i].challenge_id,
                            );
                            this.challenges[i].progress = progress;
                        }
                    }
                }
            } catch (error) {
                console.error(error);
            }
        },
        async getUserProgressForChallenge(challengeId) {
            try {
                const res = await fetch(
                    `http://localhost:3000/getUserProgress/${encodeURIComponent(this.userId)}/${encodeURIComponent(challengeId)}`,
                );
                const data = await res.json();
                return data.length > 0 ? data[0].total_progress : 0;
            } catch (error) {
                console.error(error);
                return 0;
            }
        },
        async toggleProgressForm(event) {
            this.showProgressForm = !this.showProgressForm;
            this.currentChallengeId = event.target.id;
            this.currentChallengeName = event.target.dataset.challengename;
            this.currentChallengeDescription = event.target.dataset.challengedescription;
            this.currentChallengeGoal = event.target.dataset.challengegoal;

            if (this.showProgressForm) {
                let totalUserProgress = await this.CheckUserProgress();

                if (totalUserProgress >= 100) {
                    this.$refs.saveProgressButton.disabled = true;
                }
            }
        },
        validateUserInputProgressForm() {
            if (this.progress.length === 0) {
                this.errorMessageProgressForm = 'Bitte fülle das Feld aus!';
                this.correctInputProgressForm = false;
                return;
            } else if (!this.progress.match(/^-?\d+(\.\d+)?$/)) {
                this.errorMessageProgressForm = 'Gebe bitte eine Zahl als Fortschritt an!';
                this.correctInputProgressForm = false;
                return;
            } else {
                this.correctInputProgressForm = true;
                this.errorMessageProgressForm = '';
            }
        },
        calculateProgressPercentage(progressInput, goalInput) {
            const progressNum = parseFloat(progressInput);
            const goalNum = parseFloat(goalInput);
            if (goalNum <= 0) return 0;
            return Math.round((progressNum / goalNum) * 10000) / 100;
        },
        async saveChallengeProgress() {
            const currentPercent = await this.CheckUserProgress();
            const currentAbsolute = (currentPercent / 100) * this.currentChallengeGoal;
            const newAbsolute = currentAbsolute + parseFloat(this.progress);
            const newPercent = (newAbsolute / this.currentChallengeGoal) * 100;
            const percentage = Math.round(newPercent * 100) / 100; // 2 Dezimalen

            if (percentage > 100) {
                this.errorMessageProgressForm = 'Dein Fortschritt darf nicht höher wie die Eingabe sein!';
                return;
            } else if (percentage <= 0) {
                this.errorMessageProgressForm = 'Dein Fortschritt muss größer als 0 sein!';
                return;
            }

            fetch('http://localhost:3000/addProgress', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    challenge_id: this.currentChallengeId,
                    user_id: this.userId,
                    total_progress: percentage,
                }),
            })
                .then(res => {
                    if (res.ok) {
                        this.successMessageProgressForm = 'Fortschritt gespeichert!';
                        this.errorMessageProgressForm = '';
                        this.displayChallenges(); // Refresh to update colors immediately
                    } else {
                        this.errorMessageProgressForm = 'Fehler beim Speichern des Fortschritts!';
                    }
                })
                .catch(error => {
                    console.error(error);
                    this.errorMessageProgressForm = 'Netzwerkfehler!';
                });

            if (percentage >= 100) {
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
                })
                    .then(res => res.json())
                    .then(data => {
                        fetch('http://localhost:3000/createUserBadge', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({
                                user_id: this.userId,
                                badge_id: data.badge_id,
                            }),
                        }).catch(error => {
                            console.error(error);
                        });
                    })
                    .catch(error => {
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
                } else {
                    return 0;
                }
            } catch (error) {
                console.error(error);
                return 0;
            }
        },

        deleteChallenge(event) {
            // Stop event from bubbling up to parent container, where popup is triggered
            event.stopPropagation();

            let id = Number(event.target.dataset.challengeid);

            fetch(`http://localhost:3000/deleteChallenge`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    challenge_id: id,
                }),
            })
                .then(res => {
                    if (res.ok) {
                        this.displayChallenges();
                    } else {
                        alert('Fehler beim Löschen der Challenge!');
                    }
                })
                .catch(error => {
                    console.error(error);
                    alert('Netzwerkfehler beim Löschen!');
                });
        },
        openAndClosePopUpEditChallengeForm(event) {
            // Stop event from bubbling up to parent container, where popup is triggered
            event.stopPropagation();
            this.successMessageEditChallengeForm = '';

            this.showPopUpEditChallengeForm = !this.showPopUpEditChallengeForm;
            let id = event.target.dataset.challengeid;

            if (id !== undefined) {
                this.editedChallengeId = Number(id);
                this.prefillEditChallengeForm(this.editedChallengeId);
            }
        },
        validateUserInputEditChallengeForm() {
            if (this.newChallengeTitle.length === 0) {
                this.errorMessageEditChallengeForm = 'Bitte fülle den Titel aus!';
                this.correctInput2 = false;
                return;
            }
            if (this.newChallengeDescription.length === 0) {
                this.errorMessageEditChallengeForm = 'Bitte fülle die Beschreibung aus!';
                this.correctInput2 = false;
                return;
            }
            if (this.newChallengeGoal.length === 0) {
                this.errorMessageEditChallengeForm = 'Bitte fülle das Ziel aus!';
                this.correctInput2 = false;
                return;
            } else if (
                !this.newChallengeGoal.match(/^-?\d+(\.\d+)?$/) ||
                parseFloat(this.newChallengeGoal) <= 0
            ) {
                this.errorMessageEditChallengeForm = 'Gebe bitte eine positive Zahl als Ziel an!';
                this.correctInput2 = false;
                return;
            }
            if (this.newDeadline.length === 0) {
                this.errorMessageEditChallengeForm = 'Bitte wähle ein Enddatum aus!';
                this.correctInput2 = false;
                return;
            }
            this.correctInput2 = true;
            this.errorMessageEditChallengeForm = '';
        },
        changeChallengeData() {
            fetch('http://localhost:3000/updateChallenge', {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    title: this.newChallengeTitle,
                    description: this.newChallengeDescription,
                    target: this.newChallengeGoal,
                    end_date: this.newDeadline,
                    challenge_id: this.editedChallengeId,
                }),
            })
                .then(res => {
                    if (res.ok) {
                        this.successMessageEditChallengeForm = 'Daten erfolgreich abgeändert!';
                        this.displayChallenges();
                    } else {
                        this.errorMessageEditChallengeForm = 'Fehler beim Ändern der Challenge!';
                    }
                })
                .catch(error => {
                    console.error('Fehler:', error);
                    this.errorMessageEditChallengeForm = 'Netzwerkfehler!';
                });
        },
        prefillEditChallengeForm(challengeId) {
            const challenge = this.challenges.find(c => c.challenge_id === challengeId);

            if (challenge) {
                this.newChallengeTitle = challenge.title;
                this.newChallengeDescription = challenge.description;
                this.newChallengeGoal = challenge.target;
                const date = new Date(challenge.end_date);
                this.newDeadline =
                    date.getFullYear() +
                    '-' +
                    String(date.getMonth() + 1).padStart(2, '0') +
                    '-' +
                    String(date.getDate()).padStart(2, '0');
            }
        },
        getChallengeClass(challenge) {
            const now = new Date();
            const deadline = new Date(challenge.end_date);
            deadline.setHours(23, 59, 59, 999);
            if (challenge.progress >= 100) {
                return 'completed';
            } else if (now > deadline) {
                return 'overdue';
            }
            return '';
        },
        formatDate(dateString) {
            const date = new Date(dateString);
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            return `${day}.${month}.${year}`;
        },
    },
    mounted() {
        this.displayChallenges();

        this.currentDate = new Date().toISOString().split('T')[0];
    },
};
</script>

<template>
    <div class="active-challenge-container">
        <div>
            <h3>Aktive Challenges</h3>

            <div class="wrapper-container">
                <div
                    class="challenge"
                    v-for="(data, index) in this.challenges"
                    :key="index"
                    :class="getChallengeClass(data)"
                    @click="toggleProgressForm"
                    :id="data.challenge_id"
                    :data-challengeName="data.title"
                    :data-challengeDescription="data.description"
                    :data-challengeGoal="data.target"
                >
                    <span class="no-pointer-events"
                        ><b>{{ data.title }}</b></span
                    >
                    <span class="no-pointer-events">{{ data.description }}</span>
                    <span class="no-pointer-events">{{ data.target }}</span>
                    <span class="no-pointer-events"
                        >Endet am {{ formatDate(data.end_date) }} um 23:59 Uhr</span
                    >
                    <div class="button-container">
                        <button
                            class="button"
                            v-if="data.created_by === Number(this.userId)"
                            :data-challengeId="data.challenge_id"
                            @click="openAndClosePopUpEditChallengeForm"
                        >
                            Bearbeiten
                        </button>
                        <button
                            v-if="data.created_by === Number(this.userId)"
                            :data-challengeId="data.challenge_id"
                            class="button"
                            @click="deleteChallenge"
                        >
                            Löschen
                        </button>
                    </div>
                </div>
                <div class="error-message" v-if="this.informationalMessage">
                    {{ this.informationalMessage }}
                </div>
            </div>
        </div>

        <div v-if="this.showProgressForm">
            <form>
                <h3>Fortschritt eintragen</h3>

                <label for="progress">Fortschritt</label>
                <input type="number" id="progress" name="progress" v-model="this.progress" />

                <button ref="saveProgressButton" type="button" class="button" @click="saveChallengeProgress">
                    Speichern
                </button>

                <div class="error-message" v-if="this.errorMessageProgressForm">
                    {{ this.errorMessageProgressForm }}
                </div>
                <div class="success-message" v-if="this.successMessageProgressForm">
                    {{ this.successMessageProgressForm }}
                </div>
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
        <input type="number" id="goal" name="goal" v-model="this.challengeGoal" />

        <label for="date">Enddatum</label>
        <input type="date" id="date" name="date" :min="this.currentDate" v-model="this.deadline" />

        <button type="button" class="button" @click="createNewChallenge">Erstellen</button>

        <div class="error-message" v-if="this.errorMessageCreateChallengeForm">
            {{ this.errorMessageCreateChallengeForm }}
        </div>
        <div class="success-message" v-if="this.successMessageCreateChallengeForm">
            {{ this.successMessageCreateChallengeForm }}
        </div>
    </form>

    <div class="overlay" v-if="this.showPopUpEditChallengeForm">
        <div class="popup">
            <button class="button right-position" @click="openAndClosePopUpEditChallengeForm">X</button>
            <h2>Challenge bearbeiten</h2>
            <form>
                <label for="title">Titel</label>
                <input type="text" id="title" name="title" v-model="this.newChallengeTitle" />

                <label for="description">Beschreibung</label>
                <textarea
                    id="description"
                    name="description"
                    rows="3"
                    v-model="this.newChallengeDescription"
                ></textarea>

                <label for="goal">Ziel</label>
                <input type="number" id="goal" name="goal" v-model="this.newChallengeGoal" />

                <label for="date">Enddatum</label>
                <input type="date" id="date" name="date" :min="this.currentDate" v-model="this.newDeadline" />

                <button type="button" class="button" @click="changeChallengeData">Speichern</button>

                <div class="error-message" v-if="this.errorMessageEditChallengeForm">
                    {{ this.errorMessageEditChallengeForm }}
                </div>
                <div class="success-message" v-if="this.successMessageEditChallengeForm">
                    {{ this.successMessageEditChallengeForm }}
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
.wrapper-container {
    display: flex;
    gap: 30px;
    width: 97%;
}

.button-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.active-challenge-container {
    display: flex;
    gap: 30px;
    cursor: pointer;
    margin-top: 30px;
    background: var(--white);
    border-radius: 12px;
    padding: 16px;
}

.challenge {
    display: flex;
    align-items: flex-start;
    flex-direction: column;
    gap: 15px;
    border-radius: 20px;
    padding: 12px;
    margin-bottom: 12px;
    width: fit-content;
    margin-top: 20px;
    box-shadow: 0 0 15px var(--black-transparent-2);
}

.completed {
    background-color: var(--green-3);
}

.overdue {
    background-color: var(--red-3);
}

form {
    background: var(--white);
    padding: 0 16px 16px 16px;
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

button:disabled {
    background: var(--grey);
    cursor: not-allowed;
}

/* Smartphones */
@media screen and (max-width: 767px) {
    .wrapper-container {
        flex-direction: column;
        gap: 0px;
    }

    .active-challenge-container {
        flex-direction: column;
    }
}
</style>
