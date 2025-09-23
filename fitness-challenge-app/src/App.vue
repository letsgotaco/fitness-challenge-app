<script setup></script>

<template>
    <!-- DO NOT REMOVE: Necessary to show active root -->
    <router-view></router-view>
</template>

<style>
/* global styles */
:root {
    /* colors */
    --white: #f9f9f9;
    --grey: #ddd;
    --grey-2: #e7edff;
    --light-blue: #38bdf8;
    --light-blue-2: #3b82f6;
    --black: #000000;
    --black-transparent: rgba(0, 0, 0, 0.499);
    --black-transparent-2: rgba(0, 0, 0, 0.1);
    --red: #721c24;
    --red-2: #f8d7da;
    --green: #155724;
    --green-2: #d4edda;
}

body {
    background-color: var(--white);
    margin: 0 20px 0 20px;
    padding: 0;
    font-family: Arial, sans-serif;
}

.user-icon {
    margin-top: 15px;
    width: 60px;
    height: 60px;
    cursor: pointer;
}

header nav {
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

h1,
h2,
h3 {
    margin: 0;
}

.error-message {
    padding: 10px;
    border-radius: 5px;
    margin-top: 10px;
    background: var(--red-2);
    color: var(--red);
}

.success-message {
    padding: 10px;
    border-radius: 5px;
    margin-top: 10px;
    background: var(--green-2);
    color: var(--green);
}

textarea {
    resize: none;
    font-family: Arial, sans-serif;
}

.overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: var(--black-transparent);
    display: flex;
    justify-content: center;
    align-items: center;
}

.popup {
    background: var(--white);
    padding: 20px 30px;
    border-radius: 12px;
    max-width: 90%;
}

.popup label {
    display: block;
    margin: 10px 0 5px;
}

.popup input,
.popup textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid var(--grey);
    border-radius: 8px;
    font-size: var(--font-size-small-text);
}

.router-link {
    padding: 10px 15px;
    border: none;
    border-radius: 8px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    font-size: var(--font-size-small-text);
    cursor: pointer;
    margin-bottom: 15px;
}

.close-pop-up-button {
    margin-left: 90%;
}

.no-pointer-events {
    pointer-events: none;
}

.button-2 {
    padding: 10px 15px;
    border: 1px solid var(--grey);
    border-radius: 8px;
    background: var(--grey);
    color: var(--black);
    font-size: var(--font-size-small-text);
    cursor: pointer;
    margin-top: 15px;
    width: fit-content;
    transition: all 0.3s ease;
}

.button-2:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px var(--black-transparent-2);
}

.button {
    padding: 10px 15px;
    border: 1px solid var(--grey);
    border-radius: 8px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    font-size: var(--font-size-small-text);
    cursor: pointer;
    margin-top: 15px;
    width: fit-content;
    transition: all 0.3s ease;
}

.button:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px var(--black-transparent-2);
}

.right-position {
    margin-left: 90%;
}

form input:hover,
textarea:hover,
form textarea:hover {
    border-color: var(--light-blue);
    box-shadow: 0 0 5px var(--light-blue-2);
    transform: translateY(-1px);
}

/* Smartphones */
@media screen and (max-width: 767px) {
    .popup {
        max-width: 70%;
    }
}
</style>
