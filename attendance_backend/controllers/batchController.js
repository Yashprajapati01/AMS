const pool = require('../config/db');


// Create a new batch with duplicate check
exports.createBatch = async (req, res) => {
  try {
    const { batch_name, year } = req.body;
    if (!batch_name || !year) {
      return res.status(400).json({ message: 'Batch name and year are required.' });
    }

    // Check if a batch with the same name and year already exists
    const duplicateCheck = await pool.query(
      'SELECT * FROM batches WHERE batch_name = $1 AND year = $2',
      [batch_name, year]
    );
    if (duplicateCheck.rows.length > 0) {
      return res.status(400).json({ message: 'A batch with the same name and year already exists.' });
    }

    // Insert new batch if no duplicate exists
    const result = await pool.query(
      'INSERT INTO batches (batch_name, year) VALUES ($1, $2) RETURNING *',
      [batch_name, year]
    );
    res.status(201).json({ message: 'Batch created successfully', batch: result.rows[0] });
  } catch (error) {
    console.error('Error creating batch:', error);
    res.status(500).json({ message: 'Server error during batch creation' });
  }
};


// Get all batches
exports.getBatches = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM batches ORDER BY batch_id ASC');
    res.status(200).json({ batches: result.rows });
  } catch (error) {
    console.error('Error fetching batches:', error);
    res.status(500).json({ message: 'Server error while fetching batches' });
  }
};

// Update a batch
exports.updateBatch = async (req, res) => {
  try {
    const { batch_id } = req.params;
    const { batch_name, year } = req.body;
    if (!batch_name || !year) {
      return res.status(400).json({ message: 'Batch name and year are required.' });
    }
    const result = await pool.query(
      'UPDATE batches SET batch_name = $1, year = $2 WHERE batch_id = $3 RETURNING *',
      [batch_name, year, batch_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Batch not found.' });
    }
    res.status(200).json({ message: 'Batch updated successfully', batch: result.rows[0] });
  } catch (error) {
    console.error('Error updating batch:', error);
    res.status(500).json({ message: 'Server error during batch update' });
  }
};

// Delete a batch
exports.deleteBatch = async (req, res) => {
  try {
    const { batch_id } = req.params;
    const result = await pool.query(
      'DELETE FROM batches WHERE batch_id = $1 RETURNING *',
      [batch_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Batch not found.' });
    }
    res.status(200).json({ message: 'Batch deleted successfully', batch: result.rows[0] });
  } catch (error) {
    console.error('Error deleting batch:', error);
    res.status(500).json({ message: 'Server error during batch deletion' });
  }
};
