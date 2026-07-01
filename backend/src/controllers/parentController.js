const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

// Get parent dashboard
exports.getParentDashboard = async (req, res) => {
  try {
    const parentId = req.params.parentId;

    const [parent] = await pool.query(
      'SELECT * FROM parents WHERE userId = ?',
      [parentId]
    );

    if (parent.length === 0) {
      return res.status(404).json({ message: 'Parent not found' });
    }

    // Get child data
    const [child] = await pool.query(
      'SELECT u.*, s.* FROM users u JOIN students s ON u.id = s.userId WHERE s.id = ?',
      [parent[0].childId]
    );

    res.status(200).json({
      parent: parent[0],
      child: child.length > 0 ? child[0] : null,
      message: 'Parent dashboard retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get child career recommendations
exports.getChildRecommendations = async (req, res) => {
  try {
    const parentId = req.params.parentId;

    const [parent] = await pool.query(
      'SELECT childId FROM parents WHERE userId = ?',
      [parentId]
    );

    if (parent.length === 0) {
      return res.status(404).json({ message: 'Parent not found' });
    }

    const [recommendations] = await pool.query(
      `SELECT cr.*, c.title FROM career_recommendations cr
       JOIN careers c ON cr.careerId = c.id
       WHERE cr.studentId = ?`,
      [parent[0].childId]
    );

    res.status(200).json({
      recommendations,
      message: 'Child recommendations retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get child academic profile
exports.getChildAcademic = async (req, res) => {
  try {
    const parentId = req.params.parentId;

    const [parent] = await pool.query(
      'SELECT childId FROM parents WHERE userId = ?',
      [parentId]
    );

    if (parent.length === 0) {
      return res.status(404).json({ message: 'Parent not found' });
    }

    const [results] = await pool.query(
      'SELECT * FROM academic_results WHERE studentId = ?',
      [parent[0].childId]
    );

    res.status(200).json({
      academicResults: results,
      message: 'Child academic data retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get child quiz results
exports.getChildQuizResults = async (req, res) => {
  try {
    const parentId = req.params.parentId;

    const [parent] = await pool.query(
      'SELECT childId FROM parents WHERE userId = ?',
      [parentId]
    );

    if (parent.length === 0) {
      return res.status(404).json({ message: 'Parent not found' });
    }

    // Get quiz results from quiz_questions table
    const [results] = await pool.query(
      'SELECT * FROM quiz_questions WHERE studentId = ?',
      [parent[0].childId]
    );

    res.status(200).json({
      quizResults: results,
      message: 'Child quiz results retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};