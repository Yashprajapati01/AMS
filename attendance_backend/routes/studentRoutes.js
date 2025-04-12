const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');
const adminAuthMiddleware = require('../middleware/adminAuthMiddleware');

// Apply the adminAuthMiddleware to all routes in this file
router.use(adminAuthMiddleware);
// Create a new student
router.post('/students', studentController.createStudent);

// Get students (optionally filtered by branch_id)
router.get('/students', studentController.getStudents);

// Update a student
router.put('/students/:student_id', studentController.updateStudent);

// Delete a student
router.delete('/students/:student_id', studentController.deleteStudent);

module.exports = router;
