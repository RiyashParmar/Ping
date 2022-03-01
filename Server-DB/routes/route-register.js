const express = require('express');

const registerController = require('../controllers/controller-register');

const router = express.Router();

router.post('/register/sendOtp', registerController.sendOtp);

router.post('/register/confirmOtp', registerController.confirmOtp);

router.post('/register/checkUsername', registerController.checkUsername);

router.post('/register/checkLoginkey', registerController.checkLoginkey);

router.post('/register/registerNewUser', registerController.registerNewUser);

exports.routes = router;