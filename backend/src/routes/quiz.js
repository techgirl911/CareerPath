const express = require('express');
const router = express.Router();
const quizController = require('../controllers/quizController');
const authMiddleware = require('../middleware/authMiddleware');

// Public routes
router.get('/', quizController.getAllQuizzes);
router.get('/:quizId', quizController.getQuizById);
router.get('/:quizId/questions', quizController.getQuizQuestions);

// Protected routes
router.post('/:studentId/submit', authMiddleware, quizController.submitQuizResponse);

// Admin routes
router.post('/', authMiddleware, quizController.createQuiz);

module.exports = router;