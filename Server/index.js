const express = require("express")
const mongoose = require("mongoose")
const app = express()

const dburi = "mongodb://localhost/authentication"
app.use(express.json())

mongoose.connect(dburi, {usenewurlparser: true, useunifiedtopology: true})
const db = mongoose.connection



app.listen(3234, () => 
{
  console.log("started")
});   