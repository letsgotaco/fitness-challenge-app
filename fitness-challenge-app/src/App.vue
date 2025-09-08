<script setup></script>

<template>
    <!-- Necessary to show active root -->
    <router-view></router-view>
</template>

<style>
/* global styles */
:root {
    --white: #f9f9f9;
    --light-blue: #38bdf8;
    --light-blue-2: #3b82f6;
    --black: #000000;

    --font-size-text: 19px;
    --font-size-small-text: 16px;
}

body {
    background-color: var(--white);
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
}
</style>
