<script>
export default {
    data() {
        return {
            userId: sessionStorage.getItem('user_id'),
            challengeCounter: 0,
            textPrivateGroups: '',
            textPrivateGroups2: '',
            groups: [],
            groupMember: [],
            showPopUpCreateGroupForm: false,
            showPopUpEditGroupForm: false,
            showGroupMemberContainer: false,
            groupname: '',
            description: '',
            correctInput: true,
            newGroupname: '',
            newDescription: '',
            correctInput2: '',
            errorMessage: '',
            successMessage: '',
            newGroupId: 0,
            editedGroupId: 0,
            selectedGroupMember: [],
            changedGroupMember: [],
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
            sessionStorage.setItem('groupId', event.target.value);

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
                                // Reset Array for each function call
                                this.groups = [];

                                for (let a = 0; a < userGroups.length; a++) {
                                    for (let i = 0; i < data.length; i++) {
                                        if (userGroups[a] === data[i].group_id) {
                                            this.groups.push({
                                                name: data[i].name,
                                                description: data[i].description,
                                                id: data[i].group_id,
                                                admin: data[i].created_by,
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
        openAndClosePopUp() {
            this.showPopUpCreateGroupForm = !this.showPopUpCreateGroupForm;
            this.showGroupMemberContainer = false;
        },
        openAndCloseEditGroupForm(event) {
            this.showPopUpEditGroupForm = !this.showPopUpEditGroupForm;

            if (this.showPopUpEditGroupForm) {
                this.getPossibleGroupMember();
                this.editedGroupId = event.target.id;
            }
        },
        validateUserInputCreateGroupForm() {
            if (this.description.length === 0 || this.groupname.length === 0) {
                this.errorMessage = 'Bitte fülle alle Felder aus!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }
        },
        createNewGroup() {
            this.validateUserInputCreateGroupForm();

            if (this.correctInput) {
                fetch('http://localhost:3000/createGroup', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        name: this.groupname,
                        description: this.description,
                        created_by: this.userId,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            return res.json();
                        }
                    })
                    .then(data => {
                        this.newGroupId = data.group_id;
                        this.showGroupMemberContainer = true;
                        this.successMessage = `Gruppe erfolgreich erstellt!`;
                        this.getPossibleGroupMember();
                    })
                    .catch(error => {
                        console.error('Fehler:', error);
                    });
            }
        },
        validateUserInputEditGroupForm() {
            if (this.newDescription.length === 0 || this.newGroupname.length === 0) {
                this.errorMessage = 'Bitte fülle alle Felder aus!';
                this.correctInput2 = false;
                return;
            } else {
                this.correctInput2 = true;
                this.errorMessage = '';
            }
        },
        changeGroupdata() {
            this.validateUserInputEditGroupForm();

            if (this.correctInput2) {
                fetch('http://localhost:3000/updateGroup', {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        name: this.newGroupname,
                        description: this.newDescription,
                        group_id: this.editedGroupId,
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
        changeGroupMember() {
            if (this.changedGroupMember.length > 0) {
                // Delete old group member
                fetch(`http://localhost:3000/deleteGroupMember`, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        group_id: this.editedGroupId,
                    }),
                }).catch(error => {
                    console.error(error);
                });

                for (let i = 0; i < this.changedGroupMember.length; i++) {
                    fetch('http://localhost:3000/addGroupMember', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            group_id: this.editedGroupId,
                            user_id: this.changedGroupMember[i],
                        }),
                    })
                        .then(res => {
                            if (res.ok) {
                                this.successMessage = `Mitglieder erfolgreich geändert!`;
                                window.location.reload();
                                return res.json();
                            }
                        })
                        .catch(error => {
                            console.error('Fehler:', error);
                        });
                }
            }
        },
        getPossibleGroupMember() {
            fetch(`http://localhost:3000/getUser`)
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    }
                })
                .then(data => {
                    this.groupMember = data;

                    if (this.groupMember.length === 0) {
                        this.errorMessage = 'Keine Nutzer verfügbar!';
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        },
        addGroupMember() {
            for (let i = 0; i < this.selectedGroupMember.length; i++) {
                fetch('http://localhost:3000/addGroupMember', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        group_id: this.newGroupId,
                        user_id: this.selectedGroupMember[i],
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessage = `Mitglieder erfolgreich hinzugefügt!`;
                            window.location.reload();
                            return res.json();
                        }
                    })
                    .catch(error => {
                        console.error('Fehler:', error);
                    });
            }
        },
        deleteGroup(event) {
            let id = event.target.id;

            fetch(`http://localhost:3000/deleteGroup`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    group_id: id,
                }),
            })
                .then(res => {
                    if (res.ok) {
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
                <button class="button-2" :id="data.name" :value="data.id" @click="setGroupname">
                    Zur Gruppe
                </button>
                <button
                    class="button-2"
                    :id="data.id"
                    v-if="data.admin === Number(this.userId)"
                    @click="deleteGroup"
                >
                    Löschen
                </button>

                <button
                    class="button-2"
                    :id="data.id"
                    v-if="data.admin === Number(this.userId)"
                    @click="openAndCloseEditGroupForm"
                >
                    Bearbeiten
                </button>
            </div>

            <div class="new-group-card">
                <div>
                    <h3>Neue Gruppe</h3>
                    <span>Erstelle hier eine neue private Gruppe für deine Freunde.</span>
                </div>

                <button class="button" @click="openAndClosePopUp">Gruppe erstellen</button>
            </div>
        </div>
    </div>

    <div class="overlay" v-if="this.showPopUpCreateGroupForm">
        <div class="popup">
            <button class="button right-position" @click="openAndClosePopUp">X</button>
            <h2>Neue Gruppe erstellen</h2>
            <form>
                <label for="groupname">Gruppenname</label>
                <input type="text" id="groupname" name="groupname" v-model="this.groupname" />

                <label for="description">Beschreibung</label>
                <textarea id="description" name="description" rows="4" v-model="this.description"></textarea>

                <button type="button" class="button" @click="createNewGroup">Speichern</button>
            </form>

            <div v-if="showGroupMemberContainer">
                <h2>Mitglieder hinzufügen</h2>

                <div class="group-member-container">
                    <div
                        v-for="(data, index) in this.groupMember"
                        :key="index"
                        class="group-member-option-container"
                    >
                        <input type="checkbox" :value="data.user_id" v-model="this.selectedGroupMember" />
                        <span>{{ data.username }}</span>
                    </div>
                </div>

                <button type="button" class="button" @click="addGroupMember">Speichern</button>
            </div>

            <div class="error-message" v-if="this.errorMessage">{{ this.errorMessage }}</div>
            <div class="success-message" v-if="this.successMessage">{{ this.successMessage }}</div>
        </div>
    </div>

    <div class="overlay" v-if="this.showPopUpEditGroupForm">
        <div class="popup">
            <button class="button right-position" @click="openAndCloseEditGroupForm">X</button>
            <h2>Gruppe bearbeiten</h2>
            <form>
                <label for="groupname">Gruppenname</label>
                <input type="text" id="groupname" name="groupname" v-model="this.newGroupname" />

                <label for="description">Beschreibung</label>
                <textarea
                    id="description"
                    name="description"
                    rows="4"
                    v-model="this.newDescription"
                ></textarea>

                <button type="button" class="button" @click="changeGroupdata">Speichern</button>
            </form>

            <h2>Mitglieder hinzufügen</h2>

            <div class="group-member-container">
                <div
                    v-for="(data, index) in this.groupMember"
                    :key="index"
                    class="group-member-option-container"
                >
                    <input type="checkbox" :value="data.user_id" v-model="this.changedGroupMember" />
                    <span>{{ data.username }}</span>
                </div>
            </div>

            <button type="button" class="button" @click="changeGroupMember">Speichern</button>
            <div class="error-message" v-if="this.errorMessage">{{ this.errorMessage }}</div>
            <div class="success-message" v-if="this.successMessage">{{ this.successMessage }}</div>
        </div>
    </div>
</template>

<style scoped>
.group-member-container {
    display: flex;
    align-items: flex-start;
    flex-direction: column;
    padding: 20px 0 20px 0;
}

.group-member-option-container {
    display: flex;
    align-items: center;
    justify-content: center;
}

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
    box-shadow: 0 0 15px var(--black-transparent-2);
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

.new-group-card {
    background-color: var(--white);
    padding: 20px;
    border-radius: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    gap: 15px;
    box-shadow: 0 0 15px var(--black-transparent-2);
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

/* Smartphones */
@media screen and (max-width: 767px) {
    .groups {
        flex-direction: column;
    }

    .no-group-found-container {
        width: fit-content;
    }
}
</style>
