const pool = require('../config/db');
const bcrypt = require('bcrypt');

// Create a new student with a default password "12345678"


// Create a new student with a default password "12345678"
// Also inserts a record into the users table for login authentication.
exports.createStudent = async (req, res) => {
  const client = await pool.connect();
  try {
    const { username, roll_no, branch_id } = req.body;
    const defaultPassword = "12345678";
    if (!username || !roll_no || !branch_id || !defaultPassword) {
      return res.status(400).json({ message: 'Username, roll number, and branch_id are required.' });
    }

    await client.query('BEGIN');

    // Check if the roll_no already exists in the students table
    const existing = await client.query('SELECT * FROM students WHERE roll_no = $1', [roll_no]);
    if (existing.rows.length > 0) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: 'Roll number already exists.' });
    }

    // Check if the username already exists in the users table
    const existingUser = await client.query('SELECT * FROM users WHERE username = $1', [username]);
    if (existingUser.rows.length > 0) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: 'Username already exists in user system.' });
    }

    // Hash the default password once for both tables
    const hashedPassword = await bcrypt.hash(defaultPassword, 10);

    // Insert into users table and include the name field.
    const userInsert = await client.query(
      'INSERT INTO users (username, password, role, name) VALUES ($1, $2, $3, $4) RETURNING user_id',
      [username, hashedPassword, 'student', username]
    );

    // Insert into students table – note: we now include password.
    const studentInsert = await client.query(
      'INSERT INTO students (username, roll_no, branch_id, password, user_id) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [username, roll_no, branch_id, hashedPassword, userInsert.rows[0].user_id]
    );

    await client.query('COMMIT');
    res.status(201).json({ message: 'Student created successfully', student: studentInsert.rows[0] });
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error creating student:', error);
    res.status(500).json({ message: 'Server error during student creation' });
  } finally {
    client.release();
  }
};


// Create a new student with a default password "12345678"
// Also inserts a record into the users table for login authentication.
// exports.createStudent = async (req, res) => {
//   const client = await pool.connect();
//   try {
//     const { username, roll_no, branch_id } = req.body;
//     const defaultPassword = "12345678";
//     if (!username || !roll_no || !branch_id) {
//       return res.status(400).json({ message: 'Username, roll number, and branch_id are required.' });
//     }

//     await client.query('BEGIN');

//     // Check if the roll_no already exists in the students table
//     const existing = await client.query('SELECT * FROM students WHERE roll_no = $1', [roll_no]);
//     if (existing.rows.length > 0) {
//       await client.query('ROLLBACK');
//       return res.status(400).json({ message: 'Roll number already exists.' });
//     }

//     // Check if the username already exists in the users table
//     const existingUser = await client.query('SELECT * FROM users WHERE username = $1', [username]);
//     if (existingUser.rows.length > 0) {
//       await client.query('ROLLBACK');
//       return res.status(400).json({ message: 'Username already exists in user system.' });
//     }

//     // Hash the default password once for both tables
//     const hashedPassword = await bcrypt.hash(defaultPassword, 10);

//     // Insert into users table and include the name column (using username if no separate field is provided)
//     const userInsert = await client.query(
//       'INSERT INTO users (username, password, role, name) VALUES ($1, $2, $3, $4) RETURNING user_id',
//       [username, hashedPassword, 'student', username]
//     );

//     // Insert into students table (associate user_id for reference if desired)
//     const studentInsert = await client.query(
//       'INSERT INTO students (username, roll_no, branch_id, user_id) VALUES ($1, $2, $3, $4) RETURNING *',
//       [username, roll_no, branch_id, userInsert.rows[0].user_id]
//     );

//     await client.query('COMMIT');
//     res.status(201).json({ message: 'Student created successfully', student: studentInsert.rows[0] });
//   } catch (error) {
//     await client.query('ROLLBACK');
//     console.error('Error creating student:', error);
//     res.status(500).json({ message: 'Server error during student creation' });
//   } finally {
//     client.release();
//   }
// };


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
