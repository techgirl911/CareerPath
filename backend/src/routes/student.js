const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');
const authMiddleware = require('../middleware/authMiddleware');

// All routes protected
router.use(authMiddleware);

// GET /api/students/:studentId/dashboard
router.get('/:studentId/dashboard', studentController.getStudentDashboard);

// GET /api/students/:studentId/academic-profile
router.get('/:studentId/academic-profile', studentController.getAcademicProfile);

// GET /api/students/:studentId/recommendations
router.get('/:studentId/recommendations', studentController.getCareerRecommendations);

module.exports = router;