<script setup></script>

<template>
    <!-- <router-link to="/dashboard">Zum Dashboard</router-link> -->
    <div class="container">
        <div class="form-box">
            <h1 class="title">FitFriends - Gemeinsam Challenges meistern</h1>
            <form>
                <label for="email">E-Mail</label>
                <input type="email" id="email" placeholder="you@example.com" />

                <label for="password">Passwort</label>
                <input type="password" id="password" placeholder="••••••••" />

                <div class="button-group">
                    <button type="submit" class="button login">Login</button>
                    <button type="button" class="button register">Registrieren</button>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
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
