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

app.listen(port, () => {
    console.log('server runs on http://localhost:' + port);
});
