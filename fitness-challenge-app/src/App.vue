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
    --red: #ff0000;

    /* font-sizes */
    --font-size-big-text: 24px;
    --font-size-text: 19px;
    --font-size-small-text: 16px;

    /* font-weight */
    --font-weight-bold: 900;
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
</style>
