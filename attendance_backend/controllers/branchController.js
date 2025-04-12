const pool = require('../config/db');

// Create a new branch
exports.createBranch = async (req, res) => {
  try {
    const { branch_name, program_id } = req.body;
    if (!branch_name || !program_id) {
      return res.status(400).json({ message: 'Branch name and program_id are required.' });
    }
    const result = await pool.query(
      'INSERT INTO branches (branch_name, program_id) VALUES ($1, $2) RETURNING *',
      [branch_name, program_id]
    );
    // Check if insertion returned a row
    if (!result.rows || result.rows.length === 0) {
      return res.status(500).json({ message: 'Branch not created.' });
    }
    console.log('Created branch:', result.rows[0]);
    res.status(201).json({ message: 'Branch created successfully', branch: result.rows[0] });
  } catch (error) {
    console.error('Error creating branch:', error);
    res.status(500).json({ message: 'Server error during branch creation', error: error.toString() });
  }
};

// Get all branches (optionally filtered by program_id)
exports.getBranches = async (req, res) => {
  try {
    const { program_id } = req.query;
    let query = 'SELECT * FROM branches';
    const params = [];
    if (program_id) {
      query += ' WHERE program_id = $1';
      params.push(program_id);
    }
    const result = await pool.query(query, params);
    console.log('Fetched branches:', result.rows);
    res.status(200).json({ branches: result.rows });
  } catch (error) {
    console.error('Error fetching branches:', error);
    res.status(500).json({ message: 'Server error while fetching branches', error: error.toString() });
  }
};


// Update a branch
exports.updateBranch = async (req, res) => {
  try {
    const { branch_id } = req.params;
    const { branch_name, program_id } = req.body;
    if (!branch_name || !program_id) {
      return res.status(400).json({ message: 'Branch name and program_id are required.' });
    }
    const result = await pool.query(
      'UPDATE branches SET branch_name = $1, program_id = $2 WHERE branch_id = $3 RETURNING *',
      [branch_name, program_id, branch_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Branch not found.' });
    }
    res.status(200).json({ message: 'Branch updated successfully', branch: result.rows[0] });
  } catch (error) {
    console.error('Error updating branch:', error);
    res.status(500).json({ message: 'Server error during branch update' });
  }
};

// Delete a branch
exports.deleteBranch = async (req, res) => {
  try {
    const { branch_id } = req.params;
    const result = await pool.query(
      'DELETE FROM branches WHERE branch_id = $1 RETURNING *',
      [branch_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Branch not found.' });
    }
    res.status(200).json({ message: 'Branch deleted successfully', branch: result.rows[0] });
  } catch (error) {
    console.error('Error deleting branch:', error);
    res.status(500).json({ message: 'Server error during branch deletion' });
  }
};
