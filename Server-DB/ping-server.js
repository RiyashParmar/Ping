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

var Todo = [];

server.set("socket", socket);

server.set("connectedClients", connectedClients);

server.set("Todo", Todo);

function ping() {
    for (const key in connectedClients) {
        if (Date.now() > key.expiry) {
            connectedClients.pop(key);
        }
    }
}

setInterval(ping, 36000);

socket.on('connection', (io) => {

    io.on('init', (data) => {
        for (let i = 0; i < Todo.length; i++) {
            if (data.username == Todo[i][1]) {
                io.to(io.id).emit(Todo[i][0], Todo[i][2]);
            }
        }
        var id = new Object();
        id.socketid = io.id;
        id.username = data.username;
        id.expiry = Date.now() + 30000;
        connectedClients.push(id);
    });

    io.on('heartbeat', (data) => {
        var username = data['username'];
        for (const key in connectedClients) {
            if (key['username'] == username) {
                key['expiry'] = Date.now() + 30000;
            }
        }
    });

    io.on('message', (data) => {
        var username = data['reciver'];
        for (let i = 0; i < username.length; i++) {
            for (let j = 0; j < connectedClients.length; j++) {
                if (username[i] == connectedClients[j]['username']) {
                    io.to(connectedClients[j]['socketid']).emit('message', data);
                } else if (j == username.length - 1) {
                    Todo.push(['message', username[i], data]);
                }
            }
        }
    });

    io.on('moment', (data) => {
        var username = data['reciver'];
        for (let i = 0; i < username.length; i++) {
            for (let j = 0; j < connectedClients.length; j++) {
                if (username[i] == connectedClients[j]['username']) {
                    io.to(connectedClients[j]['socketid']).emit('moment', data);
                } else {
                    Todo.push(['moment', username[i], data]);
                }
            }
        }
    });

    io.on('startparty', (data) => {
        var username = data['username'];
        for (let i = 0; i < connectedClients.length; i++) {
            if (username == connectedClients[i]['username']) {
                io.to(connectedClients[i]['socketid']).emit('startparty', data);
                io.to(io.id).emit('resparty', { 'res': '2' });
                break;
            } else {
                io.to(io.id).emit('resparty', { 'res': '0' });
            }
        }
    });

    io.on('resparty', (data) => {
        var username = data['username'];
        for (let i = 0; i < connectedClients.length; i++) {
            if (username == connectedClients[i]['username']) {
                io.to(connectedClients[i]['socketid']).emit('resparty', data);
                break;
            } else {
                io.to(io.id).emit('resparty', { 'res': '0' });
            }
        }
    });

    io.on('event', (data) => {
        var username = data['username'];
        for (let i = 0; i < connectedClients.length; i++) {
            if (username == connectedClients[i]['username']) {
                io.to(connectedClients[i]['socketid']).emit('event', data);
                break;
            } else {
                //io.to(io.id).emit('resparty', { 'res': '0' });
            }
        }
    });

    io.on('call', (data) => {
        var username = data['username'];
        var chk = 0;
        for (let i = 0; i < connectedClients.length; i++) {
            chk++;
            if (username == connectedClients[i]['username']) {
                io.to(connectedClients[i]['socketid']).emit('call', data);
                break;
            } else if (chk == connectedClients.length - 1) {
                io.to(io.id).emit('call', { 'ans': '0' });
            }
        }
    });

    io.on('connection', (data) => {
        console.log(data);
        var username = data['username'];
        var res = 0;
        for (let i = 0; i < connectedClients.length; i++) {
            res++;
            if (username == connectedClients[i]['username']) {
                io.to(connectedClients[i]['socketid']).emit('connection', data);
                break;
            } else if (res == connectedClients.length - 1) {
                //io.to(io.id).emit('err', 'user offline');
            }
        }
    });

})

//sudo mongod --fork -f /Users/nik9/Documents/MongoDB/bin/mongod.cfg -- db start...