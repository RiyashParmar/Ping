const fs = require('fs');
const otpGenerator = require('otp-generator');

const user = require('../models/user');
const chatroom = require('../models/chatroom');
const otp = require('../models/otp');

exports.auth = async (req, res, next) => {
    try {
        var lk = req.body.loginkey;
        var no = req.body.number;
        var data = await user.findOne({ loginkey: lk, number: no }, { _id: 0, loginkey: 0, face_struct: 0 });
        if (data) {
            var room = await chatroom.find({ _id: { $in: data.chatrooms } });
            if (room) {
                room.forEach(element => {
                    element.dp = fs.readFileSync(element.dp, 'base64');
                });
                data.chatrooms = room;
                data.dp = fs.readFileSync(data.dp, 'base64');
                res.status(200).json({ data: data });
            } else {
                data.dp = fs.readFileSync(data.dp, 'base64');
                res.status(200).json({ data: data });
            }
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}

exports.confirmNumber = async (req, res, next) => {
    try {
        var number = req.body.number;
        var name = req.body.name;
        if (await user.findOne({ name: name, number: number })) {
            var OTP = otpGenerator.generate(7);
            //send otp here.....
            const Otp = otp({ _id: number, otp: OTP, expiry: new Date() });
            if (await Otp.save()) {
                res.sendStatus(200);
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

exports.confirmOtp = async (req, res, next) => {
    try {
        var number = req.body.number;
        var OTP = req.body.otp;
        var result = await otp.findOne({ _id: number, otp: OTP });
        if (result) {
            if (Date.now() > result.expiry.getTime() + 600) {
                res.sendStatus(200);
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

exports.changeLoginkey = async (req, res, next) => {
    try {
        var loginkey = req.body.loginkey;
        var number = req.body.number;
        var chk = await user.updateOne({ number: number }, { $set: { loginkey: loginkey } });
        if (chk.modifiedCount > 0) {
            res.sendStatus(200);
        } else {
            res.sendStatus(404);
        }
    } catch (error) {
        console.log(error);
        res.sendStatus(500);
    }
}