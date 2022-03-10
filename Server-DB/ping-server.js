const express = require('express');
const mongoose = require('mongoose');
const parser = require('body-parser');

const appRoute = require('./routes/route-app');
const loginRoute = require('./routes/route-login');
const registerRoute = require('./routes/route-register');

const server = express();

server.use(parser.urlencoded({ extended: false, limit: '100mb' }));
server.use(parser.json({ limit: '100mb' }));

server.use(appRoute.routes);
server.use(loginRoute.routes);
server.use(registerRoute.routes);

async function main() {
    await mongoose.connect('mongodb://localhost:27017/ping'); // Db server port. Check and change    
}

main();

const Socket = server.listen(3000);

const socket = require('socket.io')(Socket);

var connectedClients = [];

function ping() {
    for (const key in connectedClients) {
        if (Date.now() > key.expiry) {
            connectedClients.pop(key);
        }
    }
}

setInterval(ping, 36000);

socket.on('connection', (io) => {
    /*console.log(io.id);
    io.on('init', (data) => {
        //console.log(data);
        var id = new Object();
        id.socketid = io.id;
        id.username = data.username;
        id.expiry = Date.now() + 30000;
        console.log(id);
        connectedClients.push(id);
    });

    io.on('heartbeat', (data) => {
        console.log(data);
        var username = data.username;
        for (const key in connectedClients) {
            if (key.username == username) {
                key.expiry = Date.now() + 30000;
            }
        }
    });*/

    io.on('message', (data) => {
        console.log(data);
        /*var username = data;
        var res;
        var ty;

        function push() {
            for (const key in connectedClients) {
                if (key.username == username) {
                    res = key;
                }
            }
            if (res) {
                io.to(res.socketid).emit('message', data);
            } else {
                clearInterval(ty);
            }
        }

        for (let index = 0; index < connectedClients.length; index++) {
            if (username == connectedClients[index].username) {
                res = connectedClients[index].socketid;
            }
        }

        if (res) {
            io.to(res.socketid).emit('message', data);
        } else {
            ty = setInterval(push, 30000);
        }*/
        io.broadcast.emit('message', data);
    });

    io.on('connection', (data) => {
        console.log(data.username);
        io.broadcast.emit('connection', data);
    });
})

//sudo mongod --fork -f /Users/nik9/Documents/MongoDB/bin/mongod.cfg -- db init...