const express = require('express');
const router = express.Router();
const parentController = require('../controllers/parentController');
const authMiddleware = require('../middleware/authMiddleware');

// All routes protected
router.use(authMiddleware);

// GET /api/parents/:parentId/dashboard
router.get('/:parentId/dashboard', parentController.getParentDashboard);

// GET /api/parents/:parentId/child/recommendations
router.get('/:parentId/child/recommendations', parentController.getChildRecommendations);

// Backward-compatible alias for older clients
router.get('/:parentId/child-recommendations', parentController.getChildRecommendations);

// GET /api/parents/:parentId/child/academic
router.get('/:parentId/child/academic', parentController.getChildAcademic);
router.get('/:parentId/child-academic', parentController.getChildAcademic);

// GET /api/parents/:parentId/child/quiz-results
router.get('/:parentId/child/quiz-results', parentController.getChildQuizResults);
router.get('/:parentId/child-quiz-results', parentController.getChildQuizResults);

module.exports = router;