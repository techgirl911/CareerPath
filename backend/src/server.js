// MUST be at the very top!
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const db = require('./models');

console.log('========== ENV VARIABLES ==========');
console.log('DB_HOST:', process.env.DB_HOST);
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PASSWORD:', process.env.DB_PASSWORD ? '***' : 'EMPTY');
console.log('DB_NAME:', process.env.DB_NAME);
console.log('===================================');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/students', require('./routes/student'));
app.use('/api/parents', require('./routes/parent'));
app.use('/api/admin', require('./routes/admin'));
app.use('/api/careers', require('./routes/career'));
app.use('/api/quizzes', require('./routes/quiz'));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(err.statusCode || 500).json({
    message: err.message || 'Internal Server Error',
  });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});