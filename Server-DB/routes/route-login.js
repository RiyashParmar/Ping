const express = require('express');

const loginController = require('../controllers/controller-login');

const router = express.Router();

router.post('/login', loginController.auth);

router.post('/login/confirmNumber', loginController.confirmNumber);

router.post('/login/confirmOtp', loginController.confirmOtp);

router.post('/login/changeLoginkey', loginController.changeLoginkey);

exports.routes = router;