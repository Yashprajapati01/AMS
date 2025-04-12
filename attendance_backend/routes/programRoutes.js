// routes/programRoutes.js
const express = require('express');
const router = express.Router();
const programController = require('../controllers/programController');
const adminAuthMiddleware = require('../middleware/adminAuthMiddleware');

// Apply the adminAuthMiddleware to all routes in this file
router.use(adminAuthMiddleware);
// Create a new program
router.post('/programs', programController.createProgram);

// Get programs (optionally filtered by batch_id)
router.get('/programs', programController.getPrograms);

// Update a program
router.put('/programs/:program_id', programController.updateProgram);

// Delete a program
router.delete('/programs/:program_id', programController.deleteProgram);

module.exports = router;
