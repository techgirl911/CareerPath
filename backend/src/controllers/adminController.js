const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

// Get admin dashboard
exports.getAdminDashboard = async (req, res) => {
  try {
    // Get statistics
    const [userStats] = await pool.query(
      'SELECT role, COUNT(*) as count FROM users GROUP BY role'
    );

    const [careerStats] = await pool.query(
      'SELECT COUNT(*) as count FROM careers'
    );

    const [quizStats] = await pool.query(
      'SELECT COUNT(*) as count FROM quizzes'
    );

    res.status(200).json({
      statistics: {
        usersByRole: userStats,
        totalCareers: careerStats[0].count,
        totalQuizzes: quizStats[0].count
      },
      message: 'Admin dashboard retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const page = req.query.page || 1;
    const limit = req.query.limit || 20;
    const offset = (page - 1) * limit;

    const [users] = await pool.query(
      'SELECT id, email, fullName, role, isActive, createdAt FROM users LIMIT ? OFFSET ?',
      [parseInt(limit), offset]
    );

    const [countResult] = await pool.query('SELECT COUNT(*) as count FROM users');
    const total = countResult[0].count;

    res.status(200).json({
      data: users,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Deactivate user
exports.deactivateUser = async (req, res) => {
  try {
    const userId = req.params.userId;

    await pool.query(
      'UPDATE users SET isActive = FALSE WHERE id = ?',
      [userId]
    );

    res.status(200).json({
      message: 'User deactivated successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Activate user
exports.activateUser = async (req, res) => {
  try {
    const userId = req.params.userId;

    await pool.query(
      'UPDATE users SET isActive = TRUE WHERE id = ?',
      [userId]
    );

    res.status(200).json({
      message: 'User activated successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create career (already in career controller, but admin specific)
exports.createCareer = async (req, res) => {
  try {
    const { title, description, salaryRange, requiredSkills, subjects, demandIndex, demandTrend } = req.body;

    if (!title || !description) {
      return res.status(400).json({ message: 'Title and description are required' });
    }

    const careerId = uuidv4();

    await pool.query(
      'INSERT INTO careers (id, title, description, salaryRange, requiredSkills, subjects, demandIndex, demandTrend) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [careerId, title, description, salaryRange, JSON.stringify(requiredSkills), JSON.stringify(subjects), demandIndex, demandTrend]
    );

    res.status(201).json({
      message: 'Career created successfully',
      careerId
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete career
exports.deleteCareer = async (req, res) => {
  try {
    const careerId = req.params.careerId;

    await pool.query(
      'DELETE FROM careers WHERE id = ?',
      [careerId]
    );

    res.status(200).json({
      message: 'Career deleted successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create quiz
exports.createQuiz = async (req, res) => {
  try {
    const { title, description, questions, year } = req.body;

    if (!title || !description) {
      return res.status(400).json({ message: 'Title and description are required' });
    }

    const quizId = uuidv4();

    await pool.query(
      'INSERT INTO quizzes (id, title, description, year) VALUES (?, ?, ?, ?)',
      [quizId, title, description, year || new Date().getFullYear()]
    );

    // Insert questions
    if (questions && Array.isArray(questions)) {
      for (let i = 0; i < questions.length; i++) {
        const q = questions[i];
        const questionId = uuidv4();
        await pool.query(
          'INSERT INTO quiz_questions (id, quizId, question, questionType, options, questionOrder) VALUES (?, ?, ?, ?, ?, ?)',
          [questionId, quizId, q.question, q.questionType, JSON.stringify(q.options), i + 1]
        );
      }
    }

    res.status(201).json({
      message: 'Quiz created successfully',
      quizId
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete quiz
exports.deleteQuiz = async (req, res) => {
  try {
    const quizId = req.params.quizId;

    await pool.query(
      'DELETE FROM quizzes WHERE id = ?',
      [quizId]
    );

    res.status(200).json({
      message: 'Quiz deleted successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};