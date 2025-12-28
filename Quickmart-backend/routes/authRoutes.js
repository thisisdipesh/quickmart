const express = require('express');
const router = express.Router();
const {
  register,
  login,
  getProfile,
} = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');
const { validate } = require('../middleware/validation');

// @route   POST /api/auth/register
router.post('/register', validate('register'), register);

// @route   POST /api/auth/login
router.post('/login', validate('login'), login);

// @route   GET /api/auth/profile
router.get('/profile', protect, getProfile);

module.exports = router;






