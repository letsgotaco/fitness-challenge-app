const express = require('express');
const mysql = require('mysql2');

const app = express();
const port = 3000;

app.use(express.json());

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

app.listen(port, () => {
    console.log('server runs on http://localhost:' + port);
});
