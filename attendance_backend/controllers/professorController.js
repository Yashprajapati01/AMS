const pool = require('../config/db');
const bcrypt = require('bcrypt');

// Create a new professor (admin creates professor credentials)
exports.createProfessor = async (req, res) => {
  try {
    const { professor_unique_id, name, department_id, password } = req.body;
    if (!professor_unique_id || !name || !department_id || !password) {
      return res.status(400).json({ message: 'All fields are required.' });
    }
    // Check for duplicate professor_unique_id
    const duplicate = await pool.query(
      'SELECT * FROM professors WHERE professor_unique_id = $1',
      [professor_unique_id]
    );
    if (duplicate.rows.length > 0) {
      return res.status(400).json({ message: 'Professor unique ID already exists.' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO professors (professor_unique_id, name, department_id, password) VALUES ($1, $2, $3, $4) RETURNING *',
      [professor_unique_id, name, department_id, hashedPassword]
    );
    res.status(201).json({ message: 'Professor created successfully', professor: result.rows[0] });
  } catch (error) {
    console.error('Error creating professor:', error);
    res.status(500).json({ message: 'Server error during professor creation' });
  }
};

// Other CRUD endpoints (get, update, delete) follow similar patterns...


// Get professors filtered by department_id
exports.getProfessors = async (req, res) => {
  try {
    const { department_id } = req.query;
    if (!department_id) {
      return res.status(400).json({ message: 'department_id query parameter is required.' });
    }
    const result = await pool.query(
      'SELECT * FROM professors WHERE department_id = $1 ORDER BY professor_id ASC',
      [department_id]
    );
    res.status(200).json({ professors: result.rows });
  } catch (error) {
    console.error('Error fetching professors:', error);
    res.status(500).json({ message: 'Server error while fetching professors' });
  }
};

// Update a professor
exports.updateProfessor = async (req, res) => {
  try {
    const { professor_id } = req.params;
    const { professor_unique_id, name, department_id } = req.body;
    if (!professor_unique_id || !name || !department_id) {
      return res.status(400).json({ message: 'Professor unique ID, name, and department_id are required.' });
    }
    // Check uniqueness of professor_unique_id (excluding current record)
    const duplicate = await pool.query(
      'SELECT * FROM professors WHERE professor_unique_id = $1 AND professor_id <> $2',
      [professor_unique_id, professor_id]
    );
    if (duplicate.rows.length > 0) {
      return res.status(400).json({ message: 'Professor unique ID already exists.' });
    }
    const result = await pool.query(
      'UPDATE professors SET professor_unique_id = $1, name = $2, department_id = $3 WHERE professor_id = $4 RETURNING *',
      [professor_unique_id, name, department_id, professor_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Professor not found.' });
    }
    res.status(200).json({ message: 'Professor updated successfully', professor: result.rows[0] });
  } catch (error) {
    console.error('Error updating professor:', error);
    res.status(500).json({ message: 'Server error during professor update' });
  }
};

// Delete a professor
exports.deleteProfessor = async (req, res) => {
  try {
    const { professor_id } = req.params;
    const result = await pool.query(
      'DELETE FROM professors WHERE professor_id = $1 RETURNING *',
      [professor_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Professor not found.' });
    }
    res.status(200).json({ message: 'Professor deleted successfully', professor: result.rows[0] });
  } catch (error) {
    console.error('Error deleting professor:', error);
    res.status(500).json({ message: 'Server error during professor deletion' });
  }
};
