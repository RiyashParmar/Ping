const mongoose = require('mongoose');

const model = mongoose.Schema({
    _id: {
        type: String,
        required: true,
    },
    otp: {
        type: String,
        required: true,
    },
    expiry: {
        type: Date,
        required: true,
    }
}, {versionKey: false});

module.exports = new mongoose.model("otp",model);