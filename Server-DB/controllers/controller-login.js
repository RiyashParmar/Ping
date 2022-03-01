const otpGenerator = require('otp-generator')

const user = require('../models/user');
const otp = require('../models/otp');

exports.auth = async (req, res, next) => {
    try {
        var lk = req.body.loginkey;
        var no = req.body.number;
        if (await user.findOne({ _id: lk, number: no })) {
            res.sendStatus(200);
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
        var OTP = otpGenerator.generate(7);
        //send otp here.....
        if (await user.findOne({ name: name, number: number })) {
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
                var key = await user.findOne({ number: number });
                res.status(200).json({ loginkey: key._id });
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