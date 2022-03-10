const express = require('express');

const appController = require('../controllers/controller-app');

const router = express.Router();

router.post('/app/checkUsers', appController.checkUsers);

router.post('/app/editInfo', appController.editInfo);

router.post('/app/confirmInfo', appController.confirmInfo);

router.post('/app/editLoginKey', appController.editLoginkey);

router.post('/app/confirmLoginkey', appController.confirmLoginkey);

router.post('/app/deleteAccount', appController.deleteAccount);

router.post('/app/confirmOtp', appController.confirmOtp);

router.post('/app/updateUser', appController.updateUser);

router.post('/app/reportBug', appController.reportBug);

router.post('/app/feedback', appController.feedback);

router.post('/app/createChatroom', appController.createChatroom);

router.post('/app/updateChatroom', appController.updateChatroom);

router.post('/app/leaveChatroom', appController.leaveChatroom);

router.post('/app/startParty', appController.startParty);

exports.routes = router;