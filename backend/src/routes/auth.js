const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

console.log('========== AUTH ROUTES LOADED ==========');

// Signup route
router.post('/signup', async (req, res, next) => {
  try {
    console.log('POST /signup - Body:', req.body);
    await authController.signup(req, res);
  } catch (error) {
    console.error('Signup route error:', error);
    next(error);
  }
});

// Login route
router.post('/login', async (req, res, next) => {
  try {
    console.log('POST /login - Body:', req.body);
    await authController.login(req, res);
  } catch (error) {
    console.error('Login route error:', error);
    next(error);
  }
});

// Get current user route
router.get('/me', async (req, res, next) => {
  try {
    console.log('GET /me');
    await authController.getCurrentUser(req, res);
  } catch (error) {
    console.error('Get user route error:', error);
    next(error);
  }
});

// Logout route
router.post('/logout', async (req, res, next) => {
  try {
    console.log('POST /logout');
    await authController.logout(req, res);
  } catch (error) {
    console.error('Logout route error:', error);
    next(error);
  }
});

module.exports = router;