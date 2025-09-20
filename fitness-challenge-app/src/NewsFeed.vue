<script>
export default {
    data() {
        return {
            errorMessage: '',
            successMessage: '',
            errorMessagePopUpCreateCommentForm: '',
            successMessagePopUpCreateCommentForm: '',
            errorMessagePopUpEditCommentForm: '',
            successMessagePopUpEditCommentForm: '',
            errorMessagePopUpEditPostForm: '',
            successMessagePopUpEditPostForm: '',
            contentPost: '',
            contentComment: '',
            contentEditedPost: '',
            contentEditedComment: '',
            correctInput: true,
            correctInput2: true,
            correctInput3: true,
            correctInput4: true,
            groupId: sessionStorage.getItem('groupId'),
            userId: sessionStorage.getItem('user_id'),
            postId: 0,
            editedPostId: 0,
            editedCommentId: 0,
            posts: [],
            showPopUpCreateCommentForm: false,
            showPopUpEditCommentForm: false,
            showPopUpEditPostForm: false,
        };
    },
    methods: {
        validateUserInputPost() {
            if (this.contentPost.length === 0) {
                this.errorMessage = 'Bitte fülle alle Felder aus!';
                this.correctInput = false;
                return;
            } else {
                this.correctInput = true;
                this.errorMessage = '';
            }
        },
        validateUserInputComment() {
            if (this.contentComment.length === 0) {
                this.errorMessagePopUpCreateCommentForm = 'Bitte fülle alle Felder aus!';
                this.correctInput2 = false;
                return;
            } else {
                this.correctInput2 = true;
                this.errorMessagePopUpCreateCommentForm = '';
            }
        },
        validateUserInputEditedComment() {
            if (this.contentEditedComment.length === 0) {
                this.errorMessagePopUpEditCommentForm = 'Bitte fülle alle Felder aus!';
                this.correctInput3 = false;
                return;
            } else {
                this.correctInput3 = true;
                this.errorMessagePopUpEditCommentForm = '';
            }
        },
        validateUserInputEditedPost() {
            if (this.contentEditedPost.length === 0) {
                this.errorMessagePopUpEditPostForm = 'Bitte fülle alle Felder aus!';
                this.correctInput4 = false;
                return;
            } else {
                this.correctInput4 = true;
                this.errorMessagePopUpEditPostForm = '';
            }
        },
        postNewsFeed() {
            this.validateUserInputPost();

            if (this.correctInput) {
                fetch('http://localhost:3000/addPost', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        group_id: this.groupId,
                        user_id: this.userId,
                        content: this.contentPost,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessage = 'Nutzer erfolgreich registriert!';
                            this.displayPosts();
                        }
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        },
        postComment() {
            this.validateUserInputComment();

            if (this.correctInput2) {
                fetch('http://localhost:3000/addComment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        post_id: this.postId,
                        user_id: this.userId,
                        content: this.contentComment,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessagePopUpCreateCommentForm = 'Nutzer erfolgreich registriert!';
                            this.displayPosts();
                        }
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        },
        editPost() {
            this.validateUserInputEditedPost();

            if (this.correctInput4) {
                fetch('http://localhost:3000/updatePost', {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        content: this.contentEditedPost,
                        post_id: this.editedPostId,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessagePopUpEditPostForm = 'Post erfolgreich abgeändert!';
                            this.displayPosts();
                        }
                    })
                    .catch(error => console.error('Fehler:', error));
            }
        },
        editComment() {
            this.validateUserInputEditedComment();

            if (this.correctInput3) {
                fetch('http://localhost:3000/updateComment', {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        content: this.contentEditedComment,
                        Comment_id: this.editedCommentId,
                    }),
                })
                    .then(res => {
                        if (res.ok) {
                            this.successMessagePopUpEditCommentForm = 'Kommentar erfolgreich abgeändert!';
                            this.displayPosts();
                        }
                    })
                    .catch(error => console.error('Fehler:', error));
            }
        },
        openAndClosePopUpCreateCommentForm(event) {
            const id = parseInt(event.currentTarget.id);

            if (!isNaN(id)) {
                this.postId = id;
            }

            this.showPopUpCreateCommentForm = !this.showPopUpCreateCommentForm;
            this.successMessagePopUpCreateCommentForm = '';
        },
        openAndClosePopUpEditCommentForm(event) {
            const id = parseInt(event.currentTarget.id);

            if (!isNaN(id)) {
                this.editedCommentId = id;
            }

            this.showPopUpEditCommentForm = !this.showPopUpEditCommentForm;
        },
        openAndClosePopUpEditPostForm(event) {
            const id = parseInt(event.currentTarget.id);

            if (!isNaN(id)) {
                this.editedPostId = id;
            }

            this.showPopUpEditPostForm = !this.showPopUpEditPostForm;
        },

        async displayPosts() {
            // Reset Array for each function call
            this.posts = [];

            const res = await fetch(`http://localhost:3000/getPosts/${encodeURIComponent(this.groupId)}`);
            if (res.ok) {
                const data = await res.json();

                if (data.length === 0) {
                    this.errorMessage = 'Keine Kommentare verfügbar!';
                }

                for (let i = 0; i < data.length; i++) {
                    this.posts.push({
                        post: {
                            id: data[i].post_id,
                            user: data[i].user_id,
                            content: data[i].content,
                        },
                        comments: [],
                    });
                }

                for (let i = 0; i < this.posts.length; i++) {
                    const resComments = await fetch(
                        `http://localhost:3000/getComments/${encodeURIComponent(this.posts[i].post.id)}`,
                    );

                    if (resComments.ok) {
                        const dataComments = await resComments.json();

                        dataComments.forEach(c => {
                            this.posts[i].comments.push({
                                user: c.user_id,
                                content: c.content,
                                id: c.comment_id,
                            });
                        });
                    }
                }
            }
        },
        deleteComment(event) {
            let id = event.target.id;

            fetch(`http://localhost:3000/deleteComment`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    comment_id: id,
                }),
            })
                .then(res => {
                    if (res.ok) {
                        this.displayPosts();
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        },
        deletePost(event) {
            let id = event.target.id;

            fetch(`http://localhost:3000/deletePost`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    post_id: id,
                }),
            })
                .then(res => {
                    if (res.ok) {
                        this.displayPosts();
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        },
    },
    mounted() {
        this.displayPosts();
    },
};
</script>

<template>
    <div class="container">
        <h3>Neue Nachricht erstellen</h3>
        <textarea class="textarea" rows="4" v-model="this.contentPost"></textarea>
        <button class="button" @click="postNewsFeed">Posten</button>
        <div class="error-message">{{ this.errorMessage }}</div>
        <div class="success-message">{{ this.successMessage }}</div>

        <div class="post-container" v-for="(data, index) in this.posts" :key="index">
            <p>{{ data.post.content }}</p>

            <div v-for="(data, index) in data.comments" :key="index">
                <p class="comment">{{ data.content }}</p>
                <div class="comment-interactions-container">
                    <button
                        type="button"
                        class="small-button"
                        :id="data.id"
                        @click="deleteComment"
                        v-if="data.user === Number(this.userId)"
                    >
                        Löschen
                    </button>
                    <button
                        type="button"
                        class="small-button"
                        :id="data.id"
                        @click="openAndClosePopUpEditCommentForm"
                        v-if="data.user === Number(this.userId)"
                    >
                        Bearbeiten
                    </button>
                </div>
            </div>

            <button
                class="button"
                :id="data.post.id"
                @click="deletePost"
                v-if="data.post.user === Number(this.userId)"
            >
                Löschen
            </button>
            <button
                class="button"
                :id="data.post.id"
                @click="openAndClosePopUpEditPostForm"
                v-if="data.post.user === Number(this.userId)"
            >
                Bearbeiten
            </button>
            <button class="button" @click="openAndClosePopUpCreateCommentForm" :id="data.post.id">
                Kommentieren
            </button>
        </div>
    </div>

    <div class="overlay" v-if="this.showPopUpCreateCommentForm">
        <div class="popup">
            <button class="close-btn close-pop-up-button" @click="openAndClosePopUpCreateCommentForm">
                X
            </button>
            <h3>Kommentar schreiben</h3>
            <textarea class="textarea" rows="4" v-model="this.contentComment"></textarea>
            <button class="button" @click="postComment">Posten</button>
            <div class="error-message">{{ this.errorMessagePopUpCreateCommentForm }}</div>
            <div class="success-message">{{ this.successMessagePopUpCreateCommentForm }}</div>
        </div>
    </div>

    <div class="overlay" v-if="this.showPopUpEditCommentForm">
        <div class="popup">
            <button class="close-btn close-pop-up-button" @click="openAndClosePopUpEditCommentForm">X</button>
            <h3>Kommentar bearbeiten</h3>
            <textarea class="textarea" rows="4" v-model="this.contentEditedComment"></textarea>
            <button class="button" @click="editComment">Posten</button>
            <div class="error-message">{{ this.errorMessagePopUpEditCommentForm }}</div>
            <div class="success-message">{{ this.successMessagePopUpEditCommentForm }}</div>
        </div>
    </div>

    <div class="overlay" v-if="this.showPopUpEditPostForm">
        <div class="popup">
            <button class="close-btn close-pop-up-button" @click="openAndClosePopUpEditPostForm">X</button>
            <h3>Post bearbeiten</h3>
            <textarea class="textarea" rows="4" v-model="this.contentEditedPost"></textarea>
            <button class="button" @click="editPost">Posten</button>
            <div class="error-message">{{ this.errorMessagePopUpEditPostForm }}</div>
            <div class="success-message">{{ this.successMessagePopUpEditPostForm }}</div>
        </div>
    </div>
</template>

<style scoped>
.comment-interactions-container {
    display: flex;
    gap: 10px;
}

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
    margin: 10px 10px 0 0;
    padding: 10px 13px;
    border: none;
    border-radius: 8px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    font-weight: var(--font-weight-bold);
    cursor: pointer;
    font-size: var(--font-size-small-text);
}

.small-button {
    padding: 5px;
    border: none;
    border-radius: 8px;
    background: linear-gradient(to bottom right, var(--light-blue), var(--light-blue-2));
    color: var(--white);
    cursor: pointer;
    font-size: var(--font-size-small-text);
}

.post-container {
    background: var(--white);
    border: 1px solid var(--grey);
    border-radius: 8px;
    padding: 12px;
    margin-top: 15px;
    font-weight: var(--font-weight-bold);
}

.comment {
    background: var(--white);
    border: 1px solid var(--grey);
    border-radius: 8px;
    padding: 12px;
    font-weight: var(--font-weight-normal);
}
</style>
