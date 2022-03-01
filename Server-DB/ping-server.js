const express = require('express');
const mongoose = require('mongoose');
const parser = require('body-parser');

const loginRoute = require('./routes/route-login');
const registerRoute = require('./routes/route-register');

const server = express();

server.use(parser.urlencoded({ extended: false, limit: '100mb' }));
server.use(parser.json({ limit: '100mb' }));

server.use(loginRoute.routes);
server.use(registerRoute.routes);

async function main() {
    await mongoose.connect('mongodb://localhost:27017/ping'); // Db server port. Check and change
    server.listen(3000);
}

main();