<script>
export default {
    data() {
        return {
            errorMessage: '',
            successMessage: '',
            contentPost: '',
            correctInput: true,
        };
    },
    methods: {
        validateUserInput() {
            if (this.contentPost.length === 0) {
                this.errorMessage = 'Bitte fülle alle Felder aus!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }
        },
        postNewsFeed() {
            this.validateUserInput();

            if (this.correctInput) {
                console.log('post');
            }
        },
        postComment() {},
    },
};
</script>

<template>
    <div class="container">
        <h3>Neue Nachricht erstellen</h3>
        <textarea class="textarea" rows="4" v-model="this.contentPost"></textarea>
        <button class="button" @click="postNewsFeed">Posten</button>
        <div class="error-message">{{ this.errorMessage }}</div>

        <!-- Display posts and comments dynamically -->
        <div class="post">
            <p>Anna hat 12 km eingetragen</p>
        </div>
    </div>
</template>

<style scoped>
.container {
    background: var(--white);
    border: 1px solid var(--grey);
    border-radius: 12px;
    padding: 20px;
    width: 400px;
    margin-top: 30px;
}

.textarea {
    margin-top: 20px;
    width: 90%;
    border: 1px solid var(--grey);
    border-radius: 8px;
    padding: 10px;
    font-size: var(--font-size-small-text);
}

.button {
    margin-top: 10px;
    padding: 10px 20px;
    border: none;
    border-radius: 8px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    font-weight: bold;
    cursor: pointer;
    font-size: var(--font-size-small-text);
}

.post {
    background: var(--white);
    border: 1px solid var(--grey);
    border-radius: 8px;
    padding: 12px;
    margin-top: 15px;
    font-weight: var(--font-weight-bold);
}
</style>
