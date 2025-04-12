// app.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();
const authRoutes = require('./routes/authRoutes');
const batchRoutes = require('./routes/batchRoutes');
const programRoutes = require('./routes/programRoutes');
const branchRoutes = require('./routes/branchRoutes');
const studentRoutes = require('./routes/studentRoutes');
const professorRoutes = require('./routes/professorRoutes');

const app = express();

app.use(cors());
app.use(express.json());

// Mount the auth routes under /api/auth
app.use('/api/auth', authRoutes);
app.use('/api/admin', batchRoutes);
app.use('/api/admin', programRoutes);
app.use('/api/admin', branchRoutes);
app.use('/api/admin', studentRoutes);
app.use('/api/admin', professorRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
