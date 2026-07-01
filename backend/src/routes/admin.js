const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const authMiddleware = require('../middleware/authMiddleware');

// All routes protected
router.use(authMiddleware);

// GET /api/admin/dashboard
router.get('/dashboard', adminController.getAdminDashboard);

// GET /api/admin/users
router.get('/users', adminController.getAllUsers);

// PUT /api/admin/users/:userId/deactivate
router.put('/users/:userId/deactivate', adminController.deactivateUser);

// PUT /api/admin/users/:userId/activate
router.put('/users/:userId/activate', adminController.activateUser);

// POST /api/admin/careers
router.post('/careers', adminController.createCareer);

// DELETE /api/admin/careers/:careerId
router.delete('/careers/:careerId', adminController.deleteCareer);

// POST /api/admin/quizzes
router.post('/quizzes', adminController.createQuiz);

// DELETE /api/admin/quizzes/:quizId
router.delete('/quizzes/:quizId', adminController.deleteQuiz);

module.exports = router;