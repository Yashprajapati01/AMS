const express = require('express');
const router = express.Router();
const branchController = require('../controllers/branchController');
const adminAuthMiddleware = require('../middleware/adminAuthMiddleware');

// Apply the adminAuthMiddleware to all routes in this file
router.use(adminAuthMiddleware);
// Create a new branch
router.post('/branches', branchController.createBranch);

// Get branches (optionally filtered by program_id)
router.get('/branches', branchController.getBranches);

module.exports = router;

// Update a branch
router.put('/branches/:branch_id', branchController.updateBranch);

// Delete a branch
router.delete('/branches/:branch_id', branchController.deleteBranch);

module.exports = router;
