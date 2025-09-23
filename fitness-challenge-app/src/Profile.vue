<script>
export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            badges: [],
            challenges: [],
            name: '',
            textBadges: '',
            textChallenges: '',
            newEmailInput: '',
            newPasswordInput: '',
            newUsernameInput: '',
            correctInput: true,
            errorMessage: '',
            successMessage: '',
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
        validateUserInput() {
            if (
                this.newEmailInput.length === 0 ||
                this.newPasswordInput.length === 0 ||
                this.newUsernameInput.length === 0
            ) {
                this.errorMessage = 'Bitte fülle alle Felder aus!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }

            const emailRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!this.newEmailInput.match(emailRegExp)) {
                this.errorMessage = 'Falsches E-Mail Format!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }
        },
        async changeLoginData() {
            this.validateUserInput();

            if (this.correctInput) {
                let passwordHash = await this.$hashPassword(this.newPasswordInput, 10);

                fetch('http://localhost:3000/updateUser', {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        username: this.newUsernameInput,
                        email: this.newEmailInput,
                        password_hash: passwordHash,
                        user_id: this.userId,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessage = 'Daten erfolgreich abgeändert!';
                        }
                    })
                    .catch(error => console.error('Fehler:', error));
            }
        },
        deleteAccount() {
            let id = Number(this.userId);

            fetch(`http://localhost:3000/deleteUser`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    user_id: id,
                }),
            })
                .then(res => {
                    if (res.ok) {
                        this.$router.push('/login');
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
            <div class="challenge-row-container">
                <span>{{ this.textChallenges }}</span>
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

        <div class="section">
            <h3>Anmeldedaten ändern</h3>
            <form>
                <label for="email">E-Mail</label>
                <input type="email" id="email" placeholder="you@example.com" v-model="this.newEmailInput" />

                <label for="password">Passwort</label>
                <input type="password" id="password" placeholder="••••••••" v-model="this.newPasswordInput" />

                <label for="name">Nutzername</label>
                <input id="name" placeholder="Dein Name" v-model="this.newUsernameInput" />

                <button type="button" @click="changeLoginData">ändern</button>

                <div class="error-message" v-if="errorMessage">{{ this.errorMessage }}</div>
                <div class="success-message" v-if="successMessage">{{ this.successMessage }}</div>
            </form>
        </div>

        <div class="section">
            <h3>Konto löschen</h3>

            <button type="button" @click="deleteAccount">Löschen</button>
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
    box-shadow: 0 0 15px var(--black-transparent-2);
    transition: all 0.3s ease;
    cursor: pointer;
}

.challenge-container:hover {
    background: var(--light-blue-2);
    color: var(--white);
    transform: translateY(-2px);
    box-shadow: 0 4px 20px var(--black-transparent-2);
}

.badge-row-container,
.challenge-row-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}

.challenge-row-container {
    flex-direction: column;
    flex-wrap: nowrap;
}

.badge-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-text);
    background: var(--white);
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 0 10px var(--black-transparent-1);
    transition: all 0.3s ease;
    cursor: pointer;
}

.badge-container:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 15px var(--black-transparent-2);
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
    background: var(--grey-1);
    margin-bottom: 20px;
    border-radius: 10px;
}

form {
    display: flex;
    flex-direction: column;
    padding-top: 20px;
}

form label {
    display: block;
    margin: 10px 0 5px;
}

form input {
    width: 300px;
    padding: 12px;
    margin-bottom: 16px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background: var(--white);
    font-size: var(--font-size-small-text);
    transition: all 0.3s ease;
}

form input:hover {
    border-color: var(--light-blue);
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
    transform: translateY(-1px);
}

button {
    padding: 10px 15px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    font-size: var(--font-size-small-text);
    cursor: pointer;
    margin-top: 15px;
    width: fit-content;
    transition: all 0.3s ease;
}

button:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.error-message {
    padding: 10px;
    border-radius: 5px;
    margin-top: 10px;
    background: #f8d7da;
    color: #721c24;
}

.success-message {
    padding: 10px;
    border-radius: 5px;
    margin-top: 10px;
    background: #d4edda;
    color: #155724;
}

@media (max-width: 768px) {
    .profile-container {
        margin-top: 20px;
    }

    .profile-header {
        padding: 15px;
        font-size: var(--font-size-text);
    }

    .section {
        padding: 15px;
        margin-bottom: 15px;
    }

    .challenge-container {
        width: 100%;
        padding: 15px;
        flex-direction: column;
        align-items: flex-start;
        gap: 10px;
    }

    .badge-row-container {
        justify-content: center;
    }

    .badge-container {
        width: 150px;
        padding: 15px;
    }

    .badge-image {
        width: 80px;
    }

    form input {
        width: 250px;
    }

    button {
        width: fit-content;
    }
}
</style>
