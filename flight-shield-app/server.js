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
      "SELECT * FROM `airlines`;",
      (error, results, fields) => {
        if(error) throw error;
        res.json(results);
      }
    );
});

app.get('/rating/:username', (req, res) => {
    connection.query(
      "SELECT * FROM `user_ratings` WHERE username = ?;", req.params.username,
      (error, results, fields) => {
        if(error) throw error;
        res.json(results);
      }
    );
});

app.route('/airlines/:id')
  .get( (req, res, next) => {
    connection.query(
      "SELECT * FROM `airlines` WHERE IATA_CODE = ?;", req.params.id,
      (error, results, fields) => {
        if(error) throw error;
        res.json(results);
      }
    );
  });

app.get('/test', async (req, res) => {
    // does not have fieldcount etc in payload
    connection.query(
        "CALL GetAirlineDelays();",
        (error, results, fields) => {
          if(error) throw error;
          console.log(results[0][0]);
          res.json(results[0][0]);
        }
      );
});

app.post('/test2', async (req, res) => {
    console.log({
        origin: req.body.origin,
        destination: req.body.destination,
        date: req.body.date,
      });

    // {"fieldCount":0,"affectedRows":0,"insertId":0,"serverStatus":2,"warningCount":0,"message":"","protocol41":true,"changedRows":0} is in index 0
    connection.query(
        "CALL GetTopRatedAirlines('"+ req.body.origin + "', '" + req.body.destination + "', '" + req.body.date + "', @airline_name1, @rating_val1, @airline_name2, @rating_val2); SELECT @airline_name1, @rating_val1; SELECT @airline_name2, @rating_val2;",
        (error, results, fields) => {
          if(error) throw error;

          console.log(results);
          res.json(results);
        }
      );
});

app.post('/test3', async (req, res) => {
    // {"fieldCount":0,"affectedRows":0,"insertId":0,"serverStatus":2,"warningCount":0,"message":"","protocol41":true,"changedRows":0} is in index 1
    connection.query(
        "CALL GetAvgDelayWithRisk('"+ req.body.origin + "', '" + req.body.destination + "', '" + req.body.date + "');",
        (error, results, fields) => {
          if(error) throw error;

          console.log(results);
          res.json(results);
        }
      );
});

app.get('/user-rating-test', (req, res) => {
    // res.render('/src/form.html');
    res.sendFile(path.join(__dirname, '/src/user-rating.html'));
  });

app.post('/user-rating-trigger', async (req, res) => {
    console.log(req.body);
    connection.query(
        "SELECT * FROM airlines WHERE IATA_CODE = ?; INSERT INTO user_ratings (username, IATA_CODE, rating) VALUES (?, ?, ?); SELECT * FROM airlines WHERE IATA_CODE = ?;",
        [req.body.iata_code, req.body.username, req.body.iata_code, req.body.rating, req.body.iata_code],
        (error, results, fields) => {
          if(error) throw error;

          console.log(results);
          res.json(results);
        }
      );
});

app.post('/delete-rating', async (req, res) => {
    console.log(req.body);
    connection.query(
        "SELECT * FROM airlines WHERE IATA_CODE = ?; DELETE FROM user_ratings WHERE username = ? AND IATA_CODE = ?; SELECT * FROM airlines WHERE IATA_CODE = ?;",
        [req.body.iata_code, req.body.username, req.body.iata_code, req.body.iata_code],
        (error, results, fields) => {
          if(error) throw error;

          console.log(results);
          res.json(results);
        }
      );
});

app.post('/update-rating', async (req, res) => {
    console.log(req.body);
    connection.query(
        "SELECT * FROM airlines WHERE IATA_CODE = ?; UPDATE user_ratings SET rating = ? WHERE username = ? AND IATA_CODE = ?; SELECT * FROM airlines WHERE IATA_CODE = ?;",
        [req.body.iata_code, req.body.rating, req.body.username, req.body.iata_code, req.body.iata_code],
        (error, results, fields) => {
          if(error) throw error;

          console.log(results);
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