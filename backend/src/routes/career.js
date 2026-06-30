const express = require('express');
const router = express.Router();
const careerController = require('../controllers/careerController');
const authMiddleware = require('../middleware/authMiddleware');

// Public routes
router.get('/', careerController.getAllCareers);
router.get('/trending', careerController.getTrendingCareers);
router.get('/search', careerController.searchCareers);
router.get('/:careerId', careerController.getCareerById);
router.get('/:careerId/market-demand', careerController.getMarketDemand);

// Protected routes (admin only)
router.post('/', authMiddleware, careerController.createCareer);

module.exports = router;