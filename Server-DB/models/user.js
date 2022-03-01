const mongoose = require('mongoose');

const model = mongoose.Schema({
    _id: {
        type: String,
        required: true,
    },
    username: {
        type: String,
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    number: {
        type: String,
        required: true,
    },
    face_struct: {
        type: String,
        required: true,
    },
    dp: {
        type: String,
        required: true,
    },
    bio: {
        type: String,
        required: true,
    },
    chatrooms: {
        type: Array,
        required: true,
    },
}, { versionKey: false });

module.exports = new mongoose.model("user", model);