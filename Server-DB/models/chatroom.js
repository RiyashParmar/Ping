const mongoose = require('mongoose');

const model = mongoose.Schema({
    _id: {
        type: String,
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    type: {
        type: String,
        Enumerator : ['group','broadcast'],
        required: true,
    },
    createdby: {
        type: String,
        required: true,
    },
    members: {
        type: Array,
        required: true,
    },
    description: {
        type: String,
        required: true,
    },
    dp: {
        type: String,
        required: true,
    },
}, {versionKey: false});

exports.chatroom = new mongoose.model("chatroom",model);