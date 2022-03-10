const mongoose = require('mongoose');

const model = mongoose.Schema({
    username: {
        type: String,
        required: true,
    },
    issue: {
        type: String,
        required: true,
    }
}, { versionKey: false });

module.exports = new mongoose.model("admin", model);