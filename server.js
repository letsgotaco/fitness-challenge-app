const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(express.json());
app.use(cors());

let connection = mysql.createConnection({
    host: 'localhost',
    port: 3307,
    user: 'root',
    password: 'password',
    database: 'databank-fitness-challenge-app',
});

// DO NOT USE: Endpoint to test connectifiy of databank
app.get('/', (req, res) => {
    connection.query('SELECT NOW() AS currentTime', (err, rows) => {
        if (err) {
            console.error('Fehler:', err);
            return;
        }
        res.send('Verbindung erfolgreich! Aktuelle Zeit: ' + rows[0].currentTime);
    });
});

// API-Endpoint for registration of user
app.get('/getUser', (req, res) => {
    connection.query('SELECT * FROM `User`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to register new User
app.post('/registerUser', (req, res) => {
    const { username, email, password_hash } = req.body;

    connection.query(
        'INSERT INTO `User` (`username`, `email`, `password_hash`) VALUES (?, ?, ?)',
        [username, email, password_hash],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to user_id from the logged in user
app.get('/getUserId/:email', async (req, res) => {
    const { email } = req.params;

    try {
        connection.execute('SELECT `user_id` FROM `User` WHERE `email` = ?', [email], (err, rows) => {
            if (err) {
                console.error(err);
            }

            if (rows.length === 0) {
                return res.status(404).json({ error: 'User not found' });
            }

            res.json(rows[0]);
        });
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint for badges of the logged in user
app.get('/getBadges/:user_id', async (req, res) => {
    const { user_id } = req.params;

    try {
        connection.execute('SELECT * FROM `User_Badge` WHERE `user_id` = ?', [user_id], (err, rows) => {
            if (err) {
                console.error(err);
            }

            res.json(rows);
        });
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint for all badges
app.get('/getAllBadges', (req, res) => {
    connection.query('SELECT * FROM `Badge`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint for challenges of the logged in user
app.get('/getChallenges/:user_id', async (req, res) => {
    const { user_id } = req.params;

    try {
        connection.execute(
            "SELECT * FROM Challenge_Participant WHERE user_id = ? AND total_progress = '100%'",
            [user_id],
            (err, rows) => {
                if (err) {
                    console.error(err);
                }

                res.json(rows);
            },
        );
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint for all Challenges
app.get('/getAllChallenges', (req, res) => {
    connection.query('SELECT * FROM `Challenge`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint for private groups of logged in user
app.get('/getPrivateGroups/:user_id', async (req, res) => {
    const { user_id } = req.params;

    try {
        connection.execute(
            'SELECT * FROM `Private_Group_Member` WHERE `user_id` = ?',
            [user_id],
            (err, rows) => {
                if (err) {
                    console.error(err);
                }

                res.json(rows);
            },
        );
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint for all Groups
app.get('/getAllGroups', (req, res) => {
    connection.query('SELECT * FROM `Private_Group`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint for all Challenge counter
app.get('/getChallengeCounter/:user_id', async (req, res) => {
    const { user_id } = req.params;

    try {
        connection.execute(
            'SELECT COUNT(*) AS total FROM `Challenge_Participant` WHERE `user_id` = ?',
            [user_id],
            (err, rows) => {
                if (err) {
                    console.error(err);
                }

                const count = rows[0].total;
                res.json({ count });
            },
        );
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint to create new Group
app.post('/createGroup', (req, res) => {
    const { name, description, created_by } = req.body;

    connection.query(
        'INSERT INTO `Private_Group` (`name`, `description`, `created_by`) VALUES (?, ?, ?)',
        [name, description, created_by],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send({
                    group_id: result.insertId,
                    name,
                    description,
                    created_by,
                });
            }
        },
    );
});

// API-Endpoint to add new group member
app.post('/addGroupMember', (req, res) => {
    const { group_id, user_id } = req.body;

    connection.query(
        'INSERT INTO `Private_Group_Member` (`group_id`, `user_id`) VALUES (?, ?)',
        [group_id, user_id],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint for all posts of a group
app.get('/getPosts/:group_id', async (req, res) => {
    const { group_id } = req.params;

    try {
        connection.execute('SELECT * FROM `Feed_Post` WHERE `group_id` = ?', [group_id], (err, rows) => {
            if (err) {
                console.error(err);
            }

            res.json(rows);
        });
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint for all comments of a post
app.get('/getComments/:post_id', async (req, res) => {
    const { post_id } = req.params;

    try {
        connection.execute('SELECT * FROM `Comment` WHERE `post_id` = ?', [post_id], (err, rows) => {
            if (err) {
                console.error(err);
            }

            res.json(rows);
        });
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint to add new post
app.post('/addPost', (req, res) => {
    const { group_id, user_id, content } = req.body;

    connection.query(
        'INSERT INTO `Feed_Post` (`group_id`, `user_id`,`content`) VALUES (?, ?, ?)',
        [group_id, user_id, content],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to add new comment
app.post('/addComment', (req, res) => {
    const { post_id, user_id, content } = req.body;

    connection.query(
        'INSERT INTO `Comment` (`post_id`, `user_id`,`content`) VALUES (?, ?, ?)',
        [post_id, user_id, content],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint for challenges of a certain group
app.get('/getGroupChallenges/:group_id', async (req, res) => {
    const { group_id } = req.params;

    try {
        connection.execute('SELECT * FROM `Challenge` WHERE group_id = ?', [group_id], (err, rows) => {
            if (err) {
                console.error(err);
            }

            res.json(rows);
        });
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint for all Challenge Participants
app.get('/getAllChallengeParticipants', (req, res) => {
    connection.query('SELECT * FROM `Challenge_Participant`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to create new Challenge in a group
app.post('/createChallenge', (req, res) => {
    const { group_id, title, description, target, end_date, created_by } = req.body;

    connection.query(
        'INSERT INTO `Challenge` (`group_id`, `title`, `description`, `target`, `end_date`, `created_by`) VALUES (?, ?, ?, ?, ?, ?)',
        [group_id, title, description, target, end_date, created_by],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to add new progress in a challenge
app.post('/addProgress', (req, res) => {
    const { challenge_id, user_id, total_progress } = req.body;

    connection.query(
        'INSERT INTO `Challenge_Participant` (`challenge_id`, `user_id`, `total_progress`) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE `total_progress` = VALUES(total_progress)',
        [challenge_id, user_id, total_progress],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to create new badge if necessay
app.post('/createBadge', async (req, res) => {
    const { name, description, icon_url } = req.body;

    connection.query(
        'INSERT IGNORE INTO `Badge` (name, description, icon_url) VALUES (?, ?, ?)',
        [name, description, icon_url],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to add user badges
app.post('/createUserBadge', (req, res) => {
    const { user_id, badge_id } = req.body;

    connection.query(
        'INSERT INTO `User_Badge` (`user_id`, `badge_id`) VALUES (?, ?)',
        [user_id, badge_id],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

app.get('/getSpecificBadgeId/:name', async (req, res) => {
    const { name } = req.params;

    try {
        connection.execute('SELECT `badge_id` FROM `Badge` WHERE `name` = ?', [name], (err, rows) => {
            if (err) {
                console.error(err);
            }

            res.json(rows);
        });
    } catch (err) {
        console.error(err);
    }
});

app.get('/getUserProgress/:user_id/:challenge_id', (req, res) => {
    const { user_id, challenge_id } = req.params;

    try {
        connection.execute(
            'SELECT `total_progress` FROM `Challenge_Participant` WHERE `user_id` = ? AND `challenge_id` = ?',
            [user_id, challenge_id],
            (err, rows) => {
                if (err) {
                    console.error(err);
                }

                res.json(rows);
            },
        );
    } catch (err) {
        console.error(err);
    }
});

// API-Endpoint to update login data
app.patch('/updateUser', (req, res) => {
    const { username, email, password_hash, user_id } = req.body;

    connection.query(
        'UPDATE `User` SET `username` = ?,`email` = ?,`password_hash`= ? WHERE `user_id` = ?',
        [username, email, password_hash, user_id],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to delete comment
app.delete('/deleteComment', (req, res) => {
    const { comment_id } = req.body;

    connection.query('DELETE FROM `Comment` WHERE `comment_id` = ?', [comment_id], (err, result) => {
        if (err) {
            console.error(err);
        } else {
            res.send(req.body);
        }
    });
});

// API-Endpoint to delete Post
app.delete('/deletePost', (req, res) => {
    const { post_id } = req.body;

    connection.query('DELETE FROM `Feed_Post` WHERE `post_id` = ?', [post_id], err => {
        if (err) {
            console.error('Error deleting comments:', err);
        } else {
            res.send(req.body);
        }
    });
});

// API-Endpoint to delete user
app.delete('/deleteUser', (req, res) => {
    const { user_id } = req.body;

    connection.query('DELETE FROM `User` WHERE `user_id` = ?', [user_id], err => {
        if (err) {
            console.error('Error deleting comments:', err);
        } else {
            res.send(req.body);
        }
    });
});

// API-Endpoint to delete groups
app.delete('/deleteGroup', (req, res) => {
    const { group_id } = req.body;

    connection.query('DELETE FROM `Private_Group` WHERE `group_id` = ?', [group_id], err => {
        if (err) {
            console.error('Error deleting comments:', err);
        } else {
            res.send(req.body);
        }
    });
});

app.listen(port, () => {
    console.log('server runs on http://localhost:' + port);
});
