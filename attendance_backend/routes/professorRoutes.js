// routes/professorRoutes.js
const express = require('express');
const router = express.Router();
const professorController = require('../controllers/professorController');

// Create a new professor
router.post('/professors', professorController.createProfessor);

// Get professors filtered by department (branch)
router.get('/professors', professorController.getProfessors);

// Update a professor
router.put('/professors/:professor_id', professorController.updateProfessor);

// Delete a professor
router.delete('/professors/:professor_id', professorController.deleteProfessor);

module.exports = router;
