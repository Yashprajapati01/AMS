// controllers/programController.js
const pool = require('../config/db');

// Create a new program
exports.createProgram = async (req, res) => {
  try {
    const { program_name, batch_id } = req.body;
    if (!program_name || !batch_id) {
      return res.status(400).json({ message: 'Program name and batch_id are required.' });
    }
    const result = await pool.query(
      'INSERT INTO programs (program_name, batch_id) VALUES ($1, $2) RETURNING *',
      [program_name, batch_id]
    );
    res.status(201).json({ message: 'Program created successfully', program: result.rows[0] });
  } catch (error) {
    console.error('Error creating program:', error);
    res.status(500).json({ message: 'Server error during program creation' });
  }
};

// Get all programs (optionally filtered by batch_id)
exports.getPrograms = async (req, res) => {
  try {
    const { batch_id } = req.query; // Optional filter
    let query = 'SELECT * FROM programs';
    let params = [];
    if (batch_id) {
      query += ' WHERE batch_id = $1';
      params.push(batch_id);
    }
    const result = await pool.query(query, params);
    res.status(200).json({ programs: result.rows });
  } catch (error) {
    console.error('Error fetching programs:', error);
    res.status(500).json({ message: 'Server error while fetching programs' });
  }
};

// Update a program
exports.updateProgram = async (req, res) => {
  try {
    const { program_id } = req.params;
    const { program_name, batch_id } = req.body;
    if (!program_name || !batch_id) {
      return res.status(400).json({ message: 'Program name and batch_id are required.' });
    }
    const result = await pool.query(
      'UPDATE programs SET program_name = $1, batch_id = $2 WHERE program_id = $3 RETURNING *',
      [program_name, batch_id, program_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Program not found.' });
    }
    res.status(200).json({ message: 'Program updated successfully', program: result.rows[0] });
  } catch (error) {
    console.error('Error updating program:', error);
    res.status(500).json({ message: 'Server error during program update' });
  }
};

// Delete a program
exports.deleteProgram = async (req, res) => {
  try {
    const { program_id } = req.params;
    const result = await pool.query(
      'DELETE FROM programs WHERE program_id = $1 RETURNING *',
      [program_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Program not found.' });
    }
    res.status(200).json({ message: 'Program deleted successfully', program: result.rows[0] });
  } catch (error) {
    console.error('Error deleting program:', error);
    res.status(500).json({ message: 'Server error during program deletion' });
  }
};
