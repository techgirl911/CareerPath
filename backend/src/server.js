require('dotenv').config();

const express = require('express');
const cors = require('cors');
const Sequelize = require('sequelize');

const app = express();
app.use(cors());
app.use(express.json());

// Database connection
const sequelize = new Sequelize(
  process.env.DB_NAME || 'careerpath',
  process.env.DB_USER || 'root',
  process.env.DB_PASSWORD || '',
  {
    host: process.env.DB_HOST || 'localhost',
    dialect: 'mysql',
    logging: false,
  }
);

console.log('========== DATABASE CONFIG ==========');
console.log('Host: localhost');
console.log('Database: careerpath');
console.log('Dialect: mysql');
console.log('=====================================');

// Test connection
sequelize.authenticate()
  .then(() => console.log('✅ Database connection successful'))
  .catch(err => console.error('❌ Connection failed:', err.message));

// Sync
sequelize.sync({ alter: true })
  .then(() => console.log('✅ Database synced successfully'))
  .catch(err => console.error('❌ Sync failed:', err.message));

// ==================== AUTH ====================

// LOGIN - Get real user from database
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const user = await sequelize.query(
      `SELECT id, fullName, email, role FROM users WHERE email = ?`,
      { replacements: [email], type: Sequelize.QueryTypes.SELECT }
    );
    
    if (user.length === 0) {
      return res.status(401).json({ message: 'Invalid email' });
    }
    
    res.json({
      token: 'token-' + Date.now(),
      user: {
        id: user[0].id,
        fullName: user[0].fullName,
        email: user[0].email,
        role: user[0].role
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Login error' });
  }
});

// SIGNUP
app.post('/api/auth/signup', (req, res) => {
  res.json({ user: { id: 'user-1', email: req.body.email } });
});

// ==================== STUDENT ====================

// Get career recommendations
app.get('/api/students/:studentId/career-recommendations', async (req, res) => {
  try {
    const recs = await sequelize.query(
      `SELECT cr.*, c.title, c.description FROM careerrecommendations cr LEFT JOIN careers c ON cr.careerId = c.id WHERE cr.studentId = ?`,
      { replacements: [req.params.studentId], type: Sequelize.QueryTypes.SELECT }
    );
    res.json({ recommendations: recs });
  } catch (err) {
    res.json({ recommendations: [] });
  }
});

// Get academic results
app.get('/api/students/:studentId/academic-results', async (req, res) => {
  try {
    const results = await sequelize.query(
      `SELECT * FROM academicresults WHERE studentId = ?`,
      { replacements: [req.params.studentId], type: Sequelize.QueryTypes.SELECT }
    );
    res.json({ academicResults: results });
  } catch (err) {
    res.json({ academicResults: [] });
  }
});

// ==================== PARENT ====================

// Get child info
app.get('/api/parents/:parentId/child', async (req, res) => {
  try {
    const child = await sequelize.query(
      `SELECT s.id, u.fullName, u.email FROM students s JOIN users u ON s.userId = u.id WHERE s.parentId = ?`,
      { replacements: [req.params.parentId], type: Sequelize.QueryTypes.SELECT }
    );
    res.json(child[0] || { message: 'Not found' });
  } catch (err) {
    res.json({ message: 'Error' });
  }
});

// Get child recommendations
app.get('/api/parents/:parentId/child-recommendations', async (req, res) => {
  try {
    const recs = await sequelize.query(
      `SELECT cr.*, c.title, c.description FROM careerrecommendations cr JOIN careers c ON cr.careerId = c.id JOIN students s ON cr.studentId = s.id WHERE s.parentId = ?`,
      { replacements: [req.params.parentId], type: Sequelize.QueryTypes.SELECT }
    );
    res.json({ recommendations: recs });
  } catch (err) {
    res.json({ recommendations: [] });
  }
});

// Get child academic
app.get('/api/parents/:parentId/child-academic', async (req, res) => {
  try {
    const results = await sequelize.query(
      `SELECT ar.* FROM academicresults ar JOIN students s ON ar.studentId = s.id WHERE s.parentId = ?`,
      { replacements: [req.params.parentId], type: Sequelize.QueryTypes.SELECT }
    );
    res.json({ academicResults: results });
  } catch (err) {
    res.json({ academicResults: [] });
  }
});

// ==================== ADMIN ====================

// Get admin dashboard
app.get('/api/admin/dashboard', async (req, res) => {
  try {
    const userCount = await sequelize.query(
      `SELECT COUNT(*) as total FROM users`,
      { type: Sequelize.QueryTypes.SELECT }
    );
    
    res.json({
      statistics: {
        totalUsers: userCount[0].total,
        totalCareers: 0,
        totalQuizzes: 0
      }
    });
  } catch (err) {
    res.json({ statistics: {} });
  }
});

// Get all users
app.get('/api/admin/users', async (req, res) => {
  try {
    const users = await sequelize.query(
      `SELECT id, fullName, email, role FROM users`,
      { type: Sequelize.QueryTypes.SELECT }
    );
    res.json(users);
  } catch (err) {
    res.json([]);
  }
});

// ==================== CAREER ====================

app.get('/api/careers', async (req, res) => {
  try {
    const careers = await sequelize.query(`SELECT * FROM careers`, { type: Sequelize.QueryTypes.SELECT });
    res.json({ careers });
  } catch (err) {
    res.json({ careers: [] });
  }
});

// ==================== QUIZ ====================

app.get('/api/quizzes', async (req, res) => {
  try {
    const quizzes = await sequelize.query(`SELECT * FROM quizzes`, { type: Sequelize.QueryTypes.SELECT });
    res.json({ quizzes });
  } catch (err) {
    res.json({ quizzes: [] });
  }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
// ==================== PARENT-CHILD LINKING ====================

// Student requests to add parent
app.post('/api/students/request-parent', async (req, res) => {
  try {
    const { studentId, parentEmail } = req.body;
    
    // Find parent by email
    const parent = await sequelize.query(
      `SELECT id FROM users WHERE email = ? AND role = 'parent'`,
      { replacements: [parentEmail], type: Sequelize.QueryTypes.SELECT }
    );
    
    if (parent.length === 0) {
      return res.status(404).json({ message: 'Parent not found' });
    }
    
    // Store pending request (using raw query since we don't have a model)
    await sequelize.query(
      `CREATE TABLE IF NOT EXISTS pending_parent_requests (
        id VARCHAR(36) PRIMARY KEY,
        studentId VARCHAR(36),
        parentId VARCHAR(36),
        status VARCHAR(20) DEFAULT 'pending',
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )`
    );
    
    await sequelize.query(
      `INSERT INTO pending_parent_requests (id, studentId, parentId, status) 
       VALUES (UUID(), ?, ?, 'pending')`,
      { replacements: [studentId, parent[0].id] }
    );
    
    res.json({ message: 'Request sent to parent' });
  } catch (error) {
    res.status(500).json({ message: 'Error sending request' });
  }
});

// Parent gets pending requests
app.get('/api/parents/:parentId/pending-requests', async (req, res) => {
  try {
    const requests = await sequelize.query(
      `SELECT pr.id, pr.studentId, u.fullName, u.email 
       FROM pending_parent_requests pr
       JOIN students s ON pr.studentId = s.id
       JOIN users u ON s.userId = u.id
       WHERE pr.parentId = ? AND pr.status = 'pending'`,
      { replacements: [req.params.parentId], type: Sequelize.QueryTypes.SELECT }
    );
    
    res.json({ requests });
  } catch (error) {
    res.json({ requests: [] });
  }
});

// Parent accepts request
app.post('/api/parents/accept-request', async (req, res) => {
  try {
    const { requestId, studentId, parentId } = req.body;
    
    // Update request status
    await sequelize.query(
      `UPDATE pending_parent_requests SET status = 'accepted' WHERE id = ?`,
      { replacements: [requestId] }
    );
    
    // Link parent to student
    await sequelize.query(
      `UPDATE students SET parentId = ? WHERE id = ?`,
      { replacements: [parentId, studentId] }
    );
    
    res.json({ message: 'Request accepted' });
  } catch (error) {
    res.status(500).json({ message: 'Error accepting request' });
  }
});

// Parent rejects request
app.post('/api/parents/reject-request', async (req, res) => {
  try {
    const { requestId } = req.body;
    
    await sequelize.query(
      `UPDATE pending_parent_requests SET status = 'rejected' WHERE id = ?`,
      { replacements: [requestId] }
    );
    
    res.json({ message: 'Request rejected' });
  } catch (error) {
    res.status(500).json({ message: 'Error rejecting request' });
  }
});