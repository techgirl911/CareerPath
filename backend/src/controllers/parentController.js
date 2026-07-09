const pool = require('../config/dbPool');
const { v4: uuidv4 } = require('uuid');

async function fetchOrCreateParentByUserId(userId) {
  const [parentRows] = await pool.query(
    'SELECT * FROM parents WHERE userId = ?',
    [userId]
  );

  if (parentRows.length > 0) {
    return parentRows[0];
  }

  const parentId = uuidv4();
  await pool.query(
    'INSERT INTO parents (id, userId, childrenCount, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?)',
    [parentId, userId, 0, new Date(), new Date()]
  );

  const [newRows] = await pool.query(
    'SELECT * FROM parents WHERE id = ?',
    [parentId]
  );

  return newRows.length > 0 ? newRows[0] : null;
}

// Get parent dashboard
exports.getParentDashboard = async (req, res) => {
  try {
    if (!req.user || req.user.role !== 'parent') {
      return res.status(403).json({ message: 'Access denied' });
    }

    if (req.params.parentId && req.params.parentId !== req.user.id) {
      return res.status(403).json({ message: 'Parent ID mismatch' });
    }

    const parent = await fetchOrCreateParentByUserId(req.user.id);
    if (!parent) {
      return res.status(404).json({ message: 'Parent record not found' });
    }

    let child = null;
    if (parent.childId) {
      const [childRows] = await pool.query(
        'SELECT u.id AS userId, u.fullName, u.email, u.role, s.* FROM users u JOIN students s ON u.id = s.userId WHERE s.id = ?',
        [parent.childId]
      );
      child = childRows.length > 0 ? childRows[0] : null;
    }

    res.status(200).json({
      parent,
      child,
      childAssigned: Boolean(parent.childId),
      message: 'Parent dashboard retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get child career recommendations
exports.getChildRecommendations = async (req, res) => {
  try {
    if (!req.user || req.user.role !== 'parent') {
      return res.status(403).json({ message: 'Access denied' });
    }

    if (req.params.parentId && req.params.parentId !== req.user.id) {
      return res.status(403).json({ message: 'Parent ID mismatch' });
    }

    const parent = await fetchOrCreateParentByUserId(req.user.id);
    if (!parent) {
      return res.status(404).json({ message: 'Parent not found' });
    }

    if (!parent.childId) {
      return res.status(200).json({
        recommendations: [],
        message: 'No child assigned to this parent yet',
      });
    }

    const [recommendations] = await pool.query(
      `SELECT cr.*, c.title FROM careerrecommendations cr
       JOIN careers c ON cr.careerId = c.id
       WHERE cr.studentId = ?`,
      [parent.childId]
    );

    res.status(200).json({
      recommendations,
      message: 'Child recommendations retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get child academic profile
exports.getChildAcademic = async (req, res) => {
  try {
    if (!req.user || req.user.role !== 'parent') {
      return res.status(403).json({ message: 'Access denied' });
    }

    if (req.params.parentId && req.params.parentId !== req.user.id) {
      return res.status(403).json({ message: 'Parent ID mismatch' });
    }

    const parent = await fetchOrCreateParentByUserId(req.user.id);
    if (!parent) {
      return res.status(404).json({ message: 'Parent not found' });
    }

    if (!parent.childId) {
      return res.status(200).json({
        academicResults: [],
        message: 'No child assigned to this parent yet',
      });
    }

    const [results] = await pool.query(
      'SELECT * FROM academicresults WHERE studentId = ?',
      [parent.childId]
    );

    res.status(200).json({
      academicResults: results,
      message: 'Child academic data retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get child quiz results
exports.getChildQuizResults = async (req, res) => {
  try {
    if (!req.user || req.user.role !== 'parent') {
      return res.status(403).json({ message: 'Access denied' });
    }

    if (req.params.parentId && req.params.parentId !== req.user.id) {
      return res.status(403).json({ message: 'Parent ID mismatch' });
    }

    const parent = await fetchOrCreateParentByUserId(req.user.id);
    if (!parent) {
      return res.status(404).json({ message: 'Parent not found' });
    }

    if (!parent.childId) {
      return res.status(200).json({
        quizResults: [],
        message: 'No child assigned to this parent yet',
      });
    }

    const [results] = await pool.query(
      'SELECT * FROM quizresponses WHERE studentId = ?',
      [parent.childId]
    );

    res.status(200).json({
      quizResults: results,
      message: 'Child quiz results retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};