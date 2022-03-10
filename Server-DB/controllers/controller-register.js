const fs = require('fs');
const otpGenerator = require('otp-generator');

const otp = require('../models/otp');
const user = require('../models/user');

exports.sendOtp = async (req, res, next) => {
    try {
        var number = req.body.number;
        if (await user.findOne({ number: number })) {
            res.sendStatus(404);
        } else {
            var OTP = otpGenerator.generate(7);
            //send otp here.....
            const Otp = otp({ _id: number, otp: OTP, expiry: new Date() });
            if (await Otp.save()) {
                res.sendStatus(200);
            } else {
                res.sendStatus(500);
            }
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.confirmOtp = async (req, res, next) => {
    try {
        var number = req.body.number;
        var OTP = req.body.otp;
        var result = await otp.findOne({ _id: number, otp: OTP });
        if (result) {
            Date.now() > result.expiry.getTime() + 600 ? res.sendStatus(200) : res.sendStatus(404);
        } else {
            res.sendStatus(500);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.checkUsername = async (req, res, next) => {
    try {
        var username = req.body.username;
        if (await user.findOne({ username: username })) {
            var ids = await _suggestUsername(username);
            res.status(404).json({ suggestions: ids });
        } else {
            res.sendStatus(200);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.checkLoginkey = async (req, res, next) => {
    try {
        var loginkey = req.body.loginkey;
        var keys = await _suggestLoginkey(loginkey);
        res.status(200).json({ suggestions: keys });
    } catch (error) {
        console.log(err);
        res.sendStatus(500);
    }
}

exports.registerNewUser = async (req, res, next) => {
    try {
        var loginkey = req.body.loginkey;
        var name = req.body.name;
        var username = req.body.username;
        var number = req.body.number;
        var face_struct = req.body.face_struct;
        var dp = req.body.dp;
        var bio = req.body.bio;

        const buffer = Buffer.from(dp, "base64");
        dp = '/Users/nik9/Documents/projects/Ping/App/Android/ping/Server-DB/imgs/' + username + '.jpg';
        fs.writeFileSync(dp, buffer);

        const User = user({ name: name, username: username, number: number, loginkey: loginkey, face_struct: face_struct, dp: dp, bio: bio, chatrooms: [] });
        if (await User.save()) {
            res.sendStatus(200);
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