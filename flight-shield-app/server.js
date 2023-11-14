require('dotenv').config()

const express = require('express');
const connection = require('./database');
const path = require('path');

const app = express();

app.use(express.urlencoded({extended: true}));

app.get('/', (req, res) => {
  res.send('Hello from App Engine! Try: /airlines');
});

app.get('/submit', (req, res) => {
  res.sendFile(path.join(__dirname, '/src/form.html'));
});

app.post('/submit', (req, res) => {
  console.log({
    name: req.body.name,
    message: req.body.message,
  });
  res.send('Thanks for your message!');
});

app.get('/airlines', (req, res) => {
    connection.query(
      "SELECT * FROM `airlines`",
      (error, results, fields) => {
        if(error) throw error;
        res.json(results);
      }
    );
});

app.route('/airlines/:id')
  .get( (req, res, next) => {
    connection.query(
      "SELECT * FROM `airlines` WHERE IATA_CODE = ?", req.params.id,
      (error, results, fields) => {
        if(error) throw error;
        res.json(results);
      }
    );
  });

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = parseInt(process.env.PORT) || 8080;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}...`);
});

module.exports = app;