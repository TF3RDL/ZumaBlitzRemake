'use strict';
var http = require('http');
var testData = {
    highscores: [
        {
            name: "Dummy01",
            score: 10000
        },
        {
            name: "Dummy02",
            score: 9000
        },
        {
            name: "Dummy03",
            score: 9000
        },
        {
            name: "Dummy04",
            score: 8000
        },
        {
            name: "Dummy05",
            score: 7000
        }
    ]
}

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'application/json'});
  res.write(JSON.stringify(testData));
  res.end();
}).listen(21723);