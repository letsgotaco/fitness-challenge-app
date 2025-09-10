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
    password: 'rootpass',
    database: 'databank-fitness-challenge-app',
});

// DO NOT USE: Endpoint to test connectifiy of databank
app.get('/', (req, res) => {
    connection.query('SELECT NOW() AS currentTime', (err, rows) => {
        if (err) {
            console.error('Fehler:', err);
            res.status(500).send('Datenbank-Fehler');
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
    let { username, email, password_hash } = req.body;
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
                return res.status(500).json({ error: err.message });
            }

            if (rows.length === 0) {
                return res.status(404).json({ error: 'User not found' });
            }

            res.json(rows[0]);
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// API-Endpoint for badges of the logged in user
app.get('/getBadges/:user_id', async (req, res) => {
    const { user_id } = req.params;

    try {
        connection.execute('SELECT * FROM `User_Badge` WHERE `user_id` = ?', [user_id], (err, rows) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }

            res.json(rows);
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
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
                    return res.status(500).json({ error: err.message });
                }

                res.json(rows);
            },
        );
    } catch (err) {
        res.status(500).json({ error: err.message });
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
                    return res.status(500).json({ error: err.message });
                }

                res.json(rows);
            },
        );
    } catch (err) {
        res.status(500).json({ error: err.message });
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
                    return res.status(500).json({ error: err.message });
                }

                const count = rows[0].total;
                res.json({ count });
            },
        );
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(port, () => {
    console.log('server runs on http://localhost:' + port);
});
