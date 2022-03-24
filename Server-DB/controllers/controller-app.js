const fs = require('fs');
const otpGenerator = require('otp-generator');

const otp = require('../models/otp');
const user = require('../models/user');
const admin = require('../models/admin');
const chatroom = require('../models/chatroom');
const { default: mongoose } = require('mongoose');

exports.checkUsers = async (req, res, next) => {
    try {
        var users = JSON.parse(req.body.users);
        var chk = [];
        for (let i = 0; i < users.length; i++) {
            var u = await user.findOne({ number: users[i] }, { _id: 0, loginkey: 0, face_struct: 0, chatrooms: 0 });
            if (u) {
                u.dp = fs.readFileSync(u.dp, 'base64');
                chk.push(u);
            }
        }
        res.json({ contacts: chk });
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.editInfo = async (req, res, next) => {
    try {
        var key = req.body.key;
        var dp = req.body.dp;
        var name = req.body.name;
        var username = req.body.username;
        var number = req.body.number;
        var bio = req.body.bio;

        if (dp != 'null') {
            const buffer = Buffer.from(dp, "base64");
            dp = '/Users/nik9/Documents/projects/Ping/App/Android/ping/Server-DB/imgs/' + username + '.jpg';
            fs.unlinkSync(dp);
            fs.writeFileSync(dp, buffer);
            var room = await user.updateOne({ username: key }, { $set: { dp: dp } });
            if (room.modifiedCount > 0) {
                dp = 'Successfully changed';
            } else {
                dp = 'Please try again';
            }
        }

        if (name != 'null') {
            var room = await user.updateOne({ username: key }, { $set: { name: name } });
            if (room.modifiedCount > 0) {
                name = 'Successfully changed';
            } else {
                name = 'Please try again';
            }
        }

        if (bio != 'null') {
            var room = await user.updateOne({ username: key }, { $set: { bio: bio } });
            if (room.modifiedCount > 0) {
                bio = 'Successfully changed';
            } else {
                bio = 'Please try again';
            }
        }

        if (number != 'null') {
            if (await user.findOne({ number: number }, { _id: 0, loginkey: 0, face_struct: 0, dp: 0, chatrooms: 0 })) {
                number = 'Number already registered';
            } else {
                var OTP = otpGenerator.generate(7);
                //send otp here.....
                const Otp = otp({ _id: number, otp: OTP, expiry: new Date() });
                if (await Otp.save()) {
                    number = 'Successfully changed';
                } else {
                    number = 'Please try again';
                }
            }
        }

        if (username != 'null') {
            if (await user.findOne({ username: username })) {
                username = await _suggestUsername(username);
            } else {
                var room = await user.updateOne({ username: key }, { $set: { username: username } });
                if (room.modifiedCount > 0) {
                    username = 'Successfully changed';
                } else {
                    username = 'Please try again';
                }
            }
        }

        res.json({ dp: dp, name: name, username: username, number: number, bio: bio });
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.confirmInfo = async (req, res, next) => {
    try {
        var key = req.body.key;
        var OTP = req.body.otp;
        var number = req.body.number
        var username = req.body.username;

        if (OTP != 'null') {
            var result = await otp.findOne({ _id: number, otp: OTP });
            if (result) {
                if (Date.now() > result.expiry.getTime() + 600) {
                    var room = await user.updateOne({ username: key }, { $set: { number: number } });
                    if (room.modifiedCount > 0) {
                        OTP = 'Changed Succesfully';
                    } else {
                        OTP = 'Something went wrong please try again';
                    }
                } else {
                    OTP = 'Otp expired! Try again';
                }
            } else {
                OTP = 'Wrong otp! Try again';
            }
        }

        if (username != 'null') {
            var room = await user.updateOne({ username: key }, { $set: { username: username } });
            if (room.modifiedCount > 0) {
                username = 'Changed Succesfully';
            } else {
                username = 'Something went wrong please try again';
            }
        }

        res.status(200).json({ username: username, number: OTP });
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.editLoginkey = async (req, res, next) => {
    try {
        var username = req.body.key;
        var Ologinkey = req.body.Ologinkey;
        var Nloginkey = req.body.Nloginkey;
        if (await user.findOne({ loginkey: Ologinkey, username: username }, { _id: 0, dp: 0, bio: 0, face_struct: 0, chatrooms: 0, number: 0, name: 0 })) {
            var keys = await _suggestLoginkey(Nloginkey);
            res.status(200).json({ suggestions: keys });
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.confirmLoginkey = async (req, res, next) => {
    try {
        var username = req.body.key;
        var loginkey = req.body.loginkey;
        var room = await user.updateOne({ username: username }, { $set: { loginkey: loginkey } });
        if (room.modifiedCount > 0) {
            res.sendStatus(200);
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.deleteAccount = async (req, res, next) => {
    try {
        var loginkey = req.body.loginkey;
        var number = req.body.number;
        if (await user.findOne({ loginkey: loginkey, number: number })) {
            var OTP = otpGenerator.generate(7);
            /// send otp here
            const Otp = otp({ _id: number, otp: OTP, expiry: new Date() });
            if (await Otp.save()) {
                res.sendStatus(200);
            } else {
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.confirmOtp = async (req, res, next) => {
    try {
        var loginkey = req.body.loginkey;
        var number = req.body.number;
        var Otp = req.body.otp;
        var rs = await otp.findOne({ _id: number, otp: Otp });
        if (rs) {
            if (Date.now() > rs.expiry.getTime() + 600) {
                var b = await user.findOne({ loginkey: loginkey, number: number });
                var room = await user.deleteOne({ loginkey: loginkey, number: number });
                if (room.deletedCount > 0) {
                    fs.unlinkSync(b.dp);
                    res.sendStatus(200);
                } else {
                    res.sendStatus(500);
                }
            } else {
                res.sendStatus(404);
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.updateUser = async (req, res, next) => {
    try {
        var username = req.body.username;
        var number = req.body.number;
        var _user = await user.findOne({ username: username, number: number }, { _id: 0, loginkey: 0, face_struct: 0, chatrooms: 0 });
        if (_user) {
            _user.dp = fs.readFileSync(_user.dp, 'base64');
            res.status(200).json({ user: _user });
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.reportBug = async (req, res, next) => {
    try {
        var username = req.body.username;
        var report = req.body.report;
        var Admin = await admin({ username: username, issue: report });
        if (await Admin.save()) {
            res.sendStatus(200);
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.feedback = async (req, res, next) => {
    try {
        var username = req.body.username;
        var feedback = req.body.feedback;
        var Admin = admin({ username: username, issue: feedback });
        if (await Admin.save()) {
            res.sendStatus(200);
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.createChatroom = async (req, res, next) => {
    try {
        const socket = req.app.get('socket');
        const connectedClients = req.app.get('connectedClients');
        const Todo = req.app.get('Todo');
        var name = req.body.name;
        var type = req.body.type;
        var createdby = req.body.createdby;
        var members = JSON.parse(req.body.members);
        var description = req.body.description;
        var dp = req.body.dp;

        members.push(createdby);
        const buffer = Buffer.from(dp, "base64");
        dp = '/Users/nik9/Documents/projects/Ping/App/Android/ping/Server-DB/imgs/' + name + '.jpg';
        fs.writeFileSync(dp, buffer);

        var room = chatroom({ name: name, type: type, createdby: createdby, members: members, description: description, dp: dp });
        if (await room.save()) {
            var room = await user.updateMany({ username: { $in: members } }, { $push: { chatrooms: room._id } });
            if (room.modifiedCount > 0) {
                room = await chatroom.findOne({ name: name, type: type, createdby: createdby, members: members, description: description, dp: dp });
                if (room.type == 'group') {
                    room.dp = fs.readFileSync(room.dp, 'base64');
                    members.pop(createdby);
                    for (let i = 0; i < members.length; i++) {
                        if (connectedClients.length == 1) {
                            Todo.push(['newroom', members[i], room]);
                        } else {
                            var chk = 0;
                            for (let j = 0; j < connectedClients.length; j++) {
                                if (connectedClients[j]['username'] == members[i]) {
                                    chk++;
                                    socket.to(connectedClients[j]['socketid']).emit('newroom', room);
                                    break;
                                } else if (j == connectedClients.length - 1 && chk == 0) {
                                    Todo.push(['newroom', members[i], room]);
                                }
                            }
                        }
                    }
                    res.status(200).json({ id: room._id });
                } else {
                    res.status(200).json({ id: room._id });
                }
            } else {
                await chatroom.deleteOne({ _id: room._id });
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.refreshChatroom = async (req, res, next) => {
    try {
        var id = req.body.id;
        var room = await chatroom.findOne({ _id: id });
        if (room) {
            room.dp = fs.readFileSync(room.dp, 'base64');
            res.status(200).json({ chatroom: room });
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.editDescription = async (req, res, next) => {
    try {
        var createdby = req.body.createdby;
        var _id = req.body._id;
        var description = req.body.description;
        var room = await chatroom.findOne({ _id: _id, createdby: createdby });
        if (room) {
            room = await chatroom.updateOne({ _id: _id, createdby: createdby }, { description: description });
            if (room.modifiedCount > 0) {
                res.sendStatus(200);
            } else {
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.addMembers = async (req, res, next) => {
    try {
        const socket = req.app.get('socket');
        const connectedClients = req.app.get('connectedClients');
        const Todo = req.app.get('Todo');
        var createdby = req.body.createdby;
        var _id = req.body._id;
        var username = req.body.username;
        var room = await chatroom.findOne({ _id: _id, createdby: createdby });
        if (room) {
            var _room = await chatroom.updateOne({ _id: _id, createdby: createdby }, { $push: { members: username } });
            if (_room.modifiedCount > 0) {
                var user = await user.updateOne({ username: username }, { $push: { chatrooms: _id } });
                if (user.modifiedCount > 0) {
                    if (room.type == 'group') {
                        room.dp = fs.readFileSync(room.dp, 'base64');
                        var chk = 0;
                        for (let i = 0; i < connectedClients.length; i++) {
                            if (connectedClients[i]['username'] == username) {
                                socket.to(connectedClients[i]['username']).emit('newroom', room);
                                res.sendStatus(200);
                                break;
                            } else if (i == connectedClients.length - 1 && chk == 0) {
                                Todo.push('newroom', username, room);
                                res.sendStatus(200);
                            }
                        }
                    } else {
                        res.sendStatus(200);
                    }
                } else {
                    await chatroom.updateOne({ _id: _id, createdby: createdby }, { $pull: { members: username } });
                    res.sendStatus(500);
                }
            } else {
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.editDp = async (req, res, next) => {
    try {
        var createdby = req.body.createdby;
        var _id = req.body._id;
        var dp = req.body.dp;
        var room = await chatroom.findOne({ _id: _id, createdby: createdby });
        if (room) {
            fs.unlinkSync(room.dp);
            const buffer = Buffer.from(dp, "base64");
            room.dp = '/Users/nik9/Documents/projects/Ping/App/Android/ping/Server-DB/imgs/' + room.name + '.jpg';
            fs.writeFileSync(room.dp, buffer);
            room = await chatroom.updateOne({ _id: _id, createdby: createdby }, { dp: room.dp });
            if (room.modifiedCount > 0) {// check.....
                res.sendStatus(200);
            } else {
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.editGroupName = async (req, res, next) => {
    try {
        var createdby = req.body.createdby;
        var _id = req.body._id;
        var name = req.body.name;
        var room = await chatroom.findOne({ _id: _id, createdby: createdby });
        if (room) {
            room = await chatroom.updateOne({ _id: _id, createdby: createdby }, { name: name });
            if (room.modifiedCount > 0) {
                res.sendStatus(200);
            } else {
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.removeMember = async (req, res, next) => {
    try {
        const socket = req.app.get('socket');
        const connectedClients = req.app.get('connectedClients');
        const Todo = req.app.get('Todo');
        var createdby = req.body.createdby;
        var _id = req.body._id;
        var username = req.body.username;
        var room = await chatroom.findOne({ _id: _id, createdby: createdby });
        if (room) {
            var _room = await chatroom.updateOne({ _id: _id, createdby: createdby }, { $pull: { members: username } });
            if (_room.modifiedCount > 0) {
                var user = user.updateOne({ username: username }, { $pull: { chatrooms: _id } });
                if (user.modifiedCount > 0) {
                    if (room.type == 'group') {
                        var chk = 0;
                        for (let i = 0; i < connectedClients.length; i++) {
                            if (connectedClients[i]['username'] == username) {
                                socket.to(connectedClients[i]['username']).emit('deleteroom', { '_id': room._id });
                                res.sendStatus(200);
                                break;
                            } else {
                                Todo.push('deleteroom', username, room);
                                res.sendStatus(200);
                            }
                        }
                    } else {
                        res.sendStatus(200);
                    }
                } else {
                    room.updateOne({ _id: _id, createdby: createdby }, { $push: { members: username } });
                    res.sendStatus(500);
                }
            } else {
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.leaveChatroom = async (req, res, next) => {
    try {
        var id = req.body.id;
        var username = req.body.username;
        var room = await chatroom.updateOne({ _id: id }, { $pull: { members: username } });
        if (room.modifiedCount > 0) {
            var b = await user.updateOne({ username: username }, { $pull: { chatrooms: id } });
            if (b.modifiedCount > 0) {
                res.sendStatus(200);
            } else {
                await chatroom.updateOne({ _id: id }, { $push: { members: username } });
                res.sendStatus(500);
            }
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

async function _suggestLoginkey(seed) {
    function _randomCaps(input) {
        var max = (Math.floor(input.length / 1.5));
        var min = (Math.floor(input.length / 4));
        var diff = max - min;

        var rand = Math.floor(Math.random() * diff);
        rand += min;

        var capPos = [];
        var result = input;

        while (capPos.length != rand) {
            var pos = Math.floor(Math.random() * input.length);
            if (capPos.includes(pos)) {
                continue;
            } else {
                capPos.push(pos);
                var cap = (result.charAt(pos)).toUpperCase();
                var slice1 = result.slice(0, pos);
                var slice2 = result.slice(pos + 1);
                result = slice1 + cap + slice2;
            }
        }
        return result;
    }

    function _randomNum(input) {
        var max = (Math.floor(input.length / 3));
        var min = (Math.floor(input.length / 5));
        var diff = max - min;

        var rand = Math.floor(Math.random() * diff);
        rand += min;

        var capPos = [];
        var result = input;

        while (capPos.length != rand) {
            var pos = Math.floor(Math.random() * input.length);
            if (capPos.includes(pos)) {
                continue;
            } else {
                capPos.push(pos);
                var slice1 = result.slice(0, pos);
                var slice2 = result.slice(pos);
                result = slice1 + (Math.floor(Math.random() * 10).toString()) + slice2;
            }
        }
        return result;
    }

    function _randomSymbol(input) {
        var max = (Math.floor(input.length / 3));
        var min = (Math.floor(input.length / 5));
        var diff = max - min;

        var rand = Math.floor(Math.random() * diff);
        rand += min;

        var symbols = ['!', '@', '#', '$', '%', '&', '*', '-', '_', '?'];
        var capPos = [];
        var result = input;

        while (capPos.length != rand) {
            var pos = Math.floor(Math.random() * input.length);
            if (capPos.includes(pos)) {
                continue;
            } else {
                capPos.push(pos);
                var slice1 = result.slice(0, pos);
                var slice2 = result.slice(pos);
                result = slice1 + symbols[Math.floor(Math.random() * symbols.length)] + slice2;
            }
        }
        return result;
    }

    async function _dbCheck(key) {
        try {
            if (await user.findOne({ loginkey: key }) != null) { // Todo - convert to binary search
                return 1;
            } else {
                return 0;
            }
        } catch (error) {
            console.log(error);
        }
    }

    async function _main() {
        while (suggestions.length != 7) {
            var caped = _randomCaps(seed);
            var numed = _randomNum(caped);
            var key = _randomSymbol(numed);
            if (await _dbCheck(key) == 1) {
                continue;
            } else {
                suggestions.includes(key) ? null : suggestions.push(key);
            }
        }
    }

    var suggestions = [];

    await _main();
    return suggestions;
}

async function _suggestUsername(seed) {
    function _rand(seed) {
        var max = (Math.floor(seed.length / 2));
        var min = (Math.floor(seed.length / 3));
        var diff = max - min;

        var rand = Math.floor(Math.random() * diff);
        rand += min;

        var chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-', '_', '.'];
        var capPos = [];
        var result = seed;

        while (capPos.length != rand) {
            var max = (Math.floor(seed.length));
            var min = (Math.floor(seed.length / 1.5));
            var diff = max - min;

            var pos = Math.floor(Math.random() * diff);
            pos += min;

            if (capPos.includes(pos)) {
                continue;
            } else {
                capPos.push(pos);
                var slice1 = result.slice(0, pos);
                var slice2 = result.slice(pos);
                result = slice1 + chars[Math.floor(Math.random() * chars.length)] + slice2;
            }
        }
        return result;
    }

    async function _dbCheck(username) {
        try {
            if (await user.findOne({ username: username }) != null) {
                return 1;
            } else {
                return 0;
            }
        } catch (error) {
            console.log(error);
        }
    }

    var suggestions = [];

    while (suggestions.length != 7) {
        var id = _rand(seed);
        if (await _dbCheck(id) == 1) {
            continue;
        } else {
            suggestions.includes(id) ? null : suggestions.push(id);
        }
    }
    return suggestions;
}