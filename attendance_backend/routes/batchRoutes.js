const express = require('express');
const router = express.Router();
const batchController = require('../controllers/batchController');
const adminAuthMiddleware = require('../middleware/adminAuthMiddleware');

// Apply the adminAuthMiddleware to all routes in this file
router.use(adminAuthMiddleware);
// Create a new batch
router.post('/batches', batchController.createBatch);

// Get all batches
router.get('/batches', batchController.getBatches);

// Update a batch
router.put('/batches/:batch_id', batchController.updateBatch);

// Delete a batch
router.delete('/batches/:batch_id', batchController.deleteBatch);

module.exports = router;
