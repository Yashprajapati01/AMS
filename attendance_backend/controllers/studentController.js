const pool = require('../config/db');
const bcrypt = require('bcrypt');

// Create a new student with a default password "12345678"
exports.createStudent = async (req, res) => {
  try {
    const { username, roll_no, branch_id } = req.body;
    const defaultPassword = "12345678";
    if (!username || !roll_no || !branch_id) {
      return res.status(400).json({ message: 'Username, roll number, and branch_id are required.' });
    }
    // Check if roll_no already exists
    const existing = await pool.query('SELECT * FROM students WHERE roll_no = $1', [roll_no]);
    if (existing.rows.length > 0) {
      return res.status(400).json({ message: 'Roll number already exists.' });
    }
    const hashedPassword = await bcrypt.hash(defaultPassword, 10);
    const result = await pool.query(
      'INSERT INTO students (username, roll_no, branch_id, password) VALUES ($1, $2, $3, $4) RETURNING *',
      [username, roll_no, branch_id, hashedPassword]
    );
    res.status(201).json({ message: 'Student created successfully', student: result.rows[0] });
  } catch (error) {
    console.error('Error creating student:', error);
    res.status(500).json({ message: 'Server error during student creation' });
  }
};

// Get all students (optionally filtered by branch_id)
exports.getStudents = async (req, res) => {
  try {
    const { branch_id } = req.query;
    let query = 'SELECT * FROM students';
    const params = [];
    if (branch_id) {
      query += ' WHERE branch_id = $1';
      params.push(branch_id);
    }
    const result = await pool.query(query, params);
    res.status(200).json({ students: result.rows });
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({ message: 'Server error while fetching students' });
  }
};

// Update a student's details (username and roll_no)
exports.updateStudent = async (req, res) => {
  try {
    const { student_id } = req.params;
    const { username, roll_no } = req.body;
    if (!username || !roll_no) {
      return res.status(400).json({ message: 'Username and roll number are required.' });
    }
    // Optionally, check for uniqueness of roll_no if it is being changed:
    const existing = await pool.query('SELECT * FROM students WHERE roll_no = $1 AND student_id <> $2', [roll_no, student_id]);
    if (existing.rows.length > 0) {
      return res.status(400).json({ message: 'Roll number already exists.' });
    }
    const result = await pool.query(
      'UPDATE students SET username = $1, roll_no = $2 WHERE student_id = $3 RETURNING *',
      [username, roll_no, student_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student not found.' });
    }
    res.status(200).json({ message: 'Student updated successfully', student: result.rows[0] });
  } catch (error) {
    console.error('Error updating student:', error);
    res.status(500).json({ message: 'Server error during student update' });
  }
};

// Delete a student
exports.deleteStudent = async (req, res) => {
  try {
    const { student_id } = req.params;
    const result = await pool.query(
      'DELETE FROM students WHERE student_id = $1 RETURNING *',
      [student_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student not found.' });
    }
    res.status(200).json({ message: 'Student deleted successfully', student: result.rows[0] });
  } catch (error) {
    console.error('Error deleting student:', error);
    res.status(500).json({ message: 'Server error during student deletion' });
  }
};
