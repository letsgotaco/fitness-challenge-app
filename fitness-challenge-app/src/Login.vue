<script>
import bcrypt from 'bcryptjs';

export default {
    data() {
        return {
            errorMessage: '',
            successMessage: '',
            emailInput: '',
            passwordInput: '',
            usernameInput: '',
            correctInput: true,
            userRegisitered: false,
            userAccountExistend: false,
        };
    },
    methods: {
        validateUserInput() {
            if (
                this.emailInput.length === 0 ||
                this.passwordInput.length === 0 ||
                this.usernameInput.length === 0
            ) {
                this.errorMessage = 'Bitte fülle alle Felder aus!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }

            const emailRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!this.emailInput.match(emailRegExp)) {
                this.errorMessage = 'Falsches E-Mail Format!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }
        },
        login() {
            this.validateUserInput();

            if (this.correctInput) {
                fetch('http://localhost:3000/getUser')
                    .then(res => {
                        if (res.ok) {
                            return res.json();
                        }
                    })
                    .then(async data => {
                        for (let i = 0; i < data.length; i++) {
                            if (data[i].email === this.emailInput) {
                                const result = await this.comparePassword(
                                    this.passwordInput,
                                    data[i].password_hash,
                                );

                                if (result) {
                                    this.getUserId();
                                    this.$router.push('/dashboard');
                                }

                                this.userAccountExistend = true;
                            }
                        }

                        if (!this.userAccountExistend) {
                            this.errorMessage = 'Nutzer existiert nicht!';
                        } else {
                            this.errorMessage = '';
                        }
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        },
        register() {
            this.validateUserInput();

            if (this.correctInput) {
                fetch('http://localhost:3000/getUser')
                    .then(res => {
                        if (res.ok) {
                            return res.json();
                        }
                    })
                    .then(async data => {
                        if (data.length === 0) {
                            let passwordHash = await this.hashPassword(this.passwordInput, 10);

                            fetch('http://localhost:3000/registerUser', {
                                method: 'POST',
                                headers: {
                                    'Access-Control-Allow-Origin': '*',
                                    'Content-Type': 'application/json',
                                },
                                body: JSON.stringify({
                                    username: this.usernameInput,
                                    email: this.emailInput,
                                    password_hash: passwordHash,
                                }).then(res => {
                                    if (res.ok) {
                                        this.successMessage = 'Nutzer erfolgreich registriert!';
                                    }
                                }),
                            }).catch(error => {
                                console.error(error);
                                return;
                            });
                        } else {
                            for (let i = 0; i < data.length; i++) {
                                if (data[i].email === this.emailInput) {
                                    this.errorMessage = 'Der Nutzer ist schon registriert!';
                                    this.userRegisitered = true;
                                    break;
                                }
                            }

                            if (!this.userRegisitered) {
                                let passwordHash = await this.hashPassword(this.passwordInput, 10);

                                fetch('http://localhost:3000/registerUser', {
                                    method: 'POST',
                                    headers: {
                                        'Access-Control-Allow-Origin': '*',
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify({
                                        username: this.usernameInput,
                                        email: this.emailInput,
                                        password_hash: passwordHash,
                                    }),
                                })
                                    .then(res => {
                                        if (res.ok) {
                                            this.successMessage = 'Nutzer erfolgreich registriert!';
                                        }
                                    })
                                    .catch(error => {
                                        console.error(error);
                                        return;
                                    });
                            }
                        }
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        },
        async hashPassword(plainPassword, saltRounds = 10) {
            try {
                const hash = await bcrypt.hash(plainPassword, saltRounds);
                return hash;
            } catch (err) {
                console.error('Fehler beim Hashen:', err);
                throw err;
            }
        },
        comparePassword(plainPassword, hashPassword) {
            return new Promise((resolve, reject) => {
                bcrypt.compare(plainPassword, hashPassword, (err, result) => {
                    if (err) {
                        console.error('Fehler beim Vergleichen des Passworts:', err);
                        this.errorMessage = 'Ein Fehler ist aufgetreten.';
                        reject(err);
                    } else {
                        if (result) {
                            this.successMessage = 'Du wirst eingeloggt!';
                        } else {
                            this.successMessage = 'Falsches Passwort!';
                        }
                        resolve(result);
                    }
                });
            });
        },
        getUserId() {
            fetch(`http://localhost:3000/getUserId/${encodeURIComponent(this.emailInput)}`)
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    console.log(data);
                    sessionStorage.setItem('user_id', data.user_id);
                    console.log('Gespeicherte ID:', sessionStorage.getItem('user_id'));
                })
                .catch(error => {
                    console.error(error);
                });
        },
    },
};
</script>

<template>
    <div class="container">
        <div class="form-box">
            <h1 class="title">FitFriends - Gemeinsam Challenges meistern</h1>
            <form>
                <label for="email">E-Mail</label>
                <input type="email" id="email" placeholder="you@example.com" v-model="this.emailInput" />

                <label for="password">Passwort</label>
                <input type="password" id="password" placeholder="••••••••" v-model="this.passwordInput" />

                <label for="name">Nutzername</label>
                <input id="name" placeholder="Dein Name" v-model="this.usernameInput" />

                <div class="button-group">
                    <button type="button" class="button login" @click="login">Login</button>
                    <button type="button" class="button register" @click="register">Registrieren</button>
                </div>

                <div class="error-message">{{ errorMessage }}</div>
                <div class="success-message">{{ successMessage }}</div>
            </form>
        </div>
    </div>
</template>

<style scoped>
.error-message {
    font-size: var(--font-size-text);
    color: var(--red);
    padding: 20px 0 0 20%;
}

.success-message {
    font-size: var(--font-size-text);
    color: var(--light-blue);
    padding: 20px 0 0 20%;
}

.container {
    margin-top: 50px;
    background-color: var(--white);
    display: flex;
    justify-content: center;
    align-items: center;
}

.form-box {
    background: var(--white);
    padding: 32px;
    border-radius: 20px;
    width: 350px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

.title {
    background: linear-gradient(90deg, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    padding: 16px;
    text-align: center;
    border-radius: 20px 20px 0 0;
    margin: -32px -32px 24px -32px;
    font-size: var(--font-size-text);
    font-weight: bold;
}

form label {
    display: block;
    margin: 8px 0 3px;
    color: #333;
}

form input {
    width: 100%;
    padding: 12px;
    margin-bottom: 16px;
    border: none;
    border-radius: 10px;
    background: var(--white);
    font-size: var(--font-size-small-text);
}

.button-group {
    display: flex;
    justify-content: space-between;
}

.button {
    padding: 12px 24px;
    font-size: var(--font-size-small-text);
    border: none;
    border-radius: 10px;
    cursor: pointer;
    flex: 1;
    margin: 0 5px;
}

.login {
    background: linear-gradient(90deg, var(--light-blue), var(--light-blue-2));
    color: var(--white);
}

.register {
    background: var(--white);
    color: var(--black);
}
</style>
