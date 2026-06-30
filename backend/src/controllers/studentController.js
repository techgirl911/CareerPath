const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

// Get student dashboard
exports.getStudentDashboard = async (req, res) => {
  try {
    const studentId = req.params.studentId;

    const [student] = await pool.query(
      'SELECT * FROM students WHERE userId = ?',
      [studentId]
    );

    if (student.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }

    res.status(200).json({
      student: student[0],
      message: 'Dashboard data retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get academic profile
exports.getAcademicProfile = async (req, res) => {
  try {
    const studentId = req.params.studentId;

    const [results] = await pool.query(
      'SELECT * FROM academic_results WHERE studentId = ?',
      [studentId]
    );

    const overallGPA = results.length > 0
      ? (results.reduce((sum, r) => sum + r.grade, 0) / results.length).toFixed(2)
      : 0;

    res.status(200).json({
      id: uuidv4(),
      studentId,
      overallGPA,
      currentSemesterGPA: results.length > 0 ? results[0].grade : 0,
      results,
      strongSubjects: results.filter(r => r.grade >= 3.5).map(r => r.subjectName),
      needsImprovement: results.filter(r => r.grade < 2.5).map(r => r.subjectName)
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get career recommendations
exports.getCareerRecommendations = async (req, res) => {
  try {
    const studentId = req.params.studentId;

    const [recommendations] = await pool.query(
      `SELECT cr.*, c.title, c.description FROM career_recommendations cr
       JOIN careers c ON cr.careerId = c.id
       WHERE cr.studentId = ?`,
      [studentId]
    );

    res.status(200).json({
      recommendations,
      message: 'Career recommendations retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};