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
    --black-transparent: rgba(0, 0, 0, 0.499) 0;
    --red: #ff0000;

    /* font-sizes */
    --font-size-big-text: 24px;
    --font-size-text: 19px;
    --font-size-small-text: 16px;

    /* font-weight */
    --font-weight-bold: 900;
    --font-weight-normal: 400;
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
    font-size: var(--font-size-text);
    color: var(--red);
    padding: 20px 0 0 20%;
}

.success-message {
    font-size: var(--font-size-text);
    color: var(--light-blue);
    padding: 20px 0 0 20%;
}

textarea {
    resize: none;
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

.popup button {
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
</style>
